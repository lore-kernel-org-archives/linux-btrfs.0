Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:54479 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaJBHod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Oct 2014 03:44:33 -0400
Received: by mail-ig0-f175.google.com with SMTP id uq10so1633314igb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 00:44:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141002065302.GF11747@carfax.org.uk>
References: <CAKZK7uzNJWSQAmaem4eZj-dcSJOvmT=-Mn53rjCbb=fNY9zEhw@mail.gmail.com>
	<CAKZK7uwWDQa_7LThjW_58+DpNQogkepuwvPhg-9bzsgyQjn14Q@mail.gmail.com>
	<20141002065302.GF11747@carfax.org.uk>
Date: Thu, 2 Oct 2014 02:44:32 -0500
Message-ID: <CAKZK7uwN1dLcc1m+WYG6ByizZkX6qVSYkKrQws5qb2nAx=Y5Hg@mail.gmail.com>
Subject: Re: Fwd: Deleting a Subvol from a Cancelled Btrfs-Send
From: Justin Brown <justin.brown@fandingo.org>
To: Hugo Mills <hugo@carfax.org.uk>, Justin Brown <justin.brown@fandingo.org>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo,

Many thanks for the help. That was far easier than I was anticipating. :)

Now that I have that cleaned up, I'm having trouble with sending the
delta. Perhaps this is a limitation of send/receive because it seems
odd that btrfs-receive doesn't have a parent option.

I'm sending a snapshot from venus to spaceman using ssh for transport.

I prepared spaceman with

~$ mkdir -p /var/media/backups/venus/
~$ sudo btrfs subvol create /var/media/backups/venus/home

Then on venus, I created a read-only snapshot and sent it spaceman:

~$ sudo btrfs sub snap -r /home home-2014-09-26
~$ sudo btrfs send -vv home-2014-09-26 | ssh root@spaceman
"/usr/sbin/btrfs receive -vv /var/media/backups/venus/home"

All good so far. Now, I'm trying to send a delta:

~$ sudo btrfs send -vv -p home-2014-09-26 home-2014-10-01 | ssh
root@spaceman "/usr/sbin/btrfs receive -vv
/var/media/backups/venus/home"

receiving snapshot home-2014-10-01
uuid=60dd57bd-4cd0-394c-ba85-065f646829d7, ctransid=446614
parent_uuid=a994d4b5-6c89-9442-a5cc-ffa1d74b9847,
parent_ctransid=432944
At snapshot home-2014-10-01
It seems that you have changed your default subvolume or you specify
other subvolume to
mount btrfs, try to remount this btrfs filesystem with fs tree, and
run btrfs receive again!

I'm not sure what "fs tree" is supposed to mean, and Google didn't
have anything useful. On spaceman, the target btrfs file system is
multi-device RAID10 with the "media" subvol mounted at /var/media and
"ovirt" subvol at /var/ovirt. There are also the subvols
"backups/venus/home" and "backups/venus/home/home-2014-09-26," which I
suppose is only mounted because I haven't rebooted or unmounted since
creating and sending them, respectively.

This seems like it's falling into the third caveat from `man btrfs-receive`:

3. default subvolume is changed or you don’t mount btrfs filesystem
with fs tree.

I don't have any idea what that means, and the Btrfs mount options
page (https://btrfs.wiki.kernel.org/index.php/Mount_options) doesn't
provide any help.

In a vain effort, I tried setting setting the default subvolume to both

~$ sudo btrfs subvolume set-default 4169
/var/media/backups/venus/home/home-2014-09-26

and then

~$ sudo btrfs subvolume set-default 4170
/var/media/backups/venus/home/home-2014-09-26

Neither had any effect on the error output.

It really seems like the command should be something like:

~$ sudo btrfs send -vv -p home-2014-09-26 home-2014-10-01 | ssh
root@spaceman.lab.fandingo.org "/usr/sbin/btrfs receive -vv -p
/var/media/backups/venus/home/home-2014-09-26
/var/media/backups/venus/home/"

Any idea what's happening? I can't find a single example online of
sending a delta over ssh.

Thanks,
Justin

On Thu, Oct 2, 2014 at 1:53 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Oct 02, 2014 at 12:05:39AM -0500, Justin Brown wrote:
>> I'm experimenting with btrfs-send. Previously (2014-09-26), I did my
>> first btrfs-send on a subvol, and that worked fine. Today, I tried to
>> send a new snapshot. Unfortunately, I realized part way through that I
>> forgot to specify the parent to only send a delta, and killed the send
>> with ^C.
>>
>> On the destination, I'm left with:
>>
>> ~$ sudo btrfs subvol list /var/media/backups/venus/home/
>> ID 2820 gen 57717 top level 5 path media
>> ID 2821 gen 57402 top level 5 path ovirt
>> ID 4169 gen 57703 top level 2820 path media/backups/venus/home
>> ID 4170 gen 57575 top level 4169 path home-2014-09-26
>> ID 4243 gen 57707 top level 4169 path home-2014-10-01
>>
>> Home-2014-10-01 was the partial send that was cancelled. I figured
>> that I could delete this partial subvol and try again.
>>
>> ~$ sudo btrfs subvol del home-2014-10-01
>> Transaction commit: none (default)
>> ERROR: error accessing 'home-2014-10-01'
>
>    If you're not doing this from /var/media/backups/venus/home/ it
> won't succeed. You need to specify (either via a relative path or an
> absolute one) where the subvol is, not just what its name is.
>
>    (Consider what happens if you have two filesystems, each with a
> home-2014-09-26 subvol.)
>
>    Hugo.
>
>> Obviously, trying to delete the subvol directory fails too:
>>
>> ~$ sudo rm -rf /var/media/backups/venus/home/home-2014-10-01/
>> rm: cannot remove ‘/var/media/backups/venus/home/home-2014-10-01/’:
>> Operation not permitted
>>
>> Is there anyway to delete this partial subvol?
>>
>> Thanks,
>> Justin
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>            --- All hope abandon,  Ye who press Enter here. ---
