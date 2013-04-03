Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:65419 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759306Ab3DCCXj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 22:23:39 -0400
Received: by mail-la0-f45.google.com with SMTP id er20so981691lab.4
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2013 19:23:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFWF=ak0uG-7_zka6WSSztRnVBESsnB+M+ia1fXi5Ncm3nGOQA@mail.gmail.com>
References: <CAFWF=ak8pDRocvUgWuTHK+6SCOoCiuNAbhY_FNwwifsT+u6VHw@mail.gmail.com>
 <CAFWF=ak0uG-7_zka6WSSztRnVBESsnB+M+ia1fXi5Ncm3nGOQA@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Wed, 3 Apr 2013 04:23:17 +0200
Message-ID: <CAFWF=a=iuvwUdSe7JuH3fMF1vugv4J90nV2D2cZV0E_LXj8RWQ@mail.gmail.com>
Subject: Re: Backup Options
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 3, 2013 at 1:29 AM, Harald Glatt <mail@hachre.de> wrote:
> On Tue, Apr 2, 2013 at 7:37 PM, Harald Glatt <mail@hachre.de> wrote:
>> Hi list,
>>
>> what are currently the backup options for btrfs?
>>
>> Is it possible to somehow duplicate the entire filesystem including
>> all snapshots without using the real space for each snapshot onto a
>> remote server? (Maybe given the remote server uses btrfs too?) Are
>> these features planned?
>>
>> Right now the only solution I know of is dd if=eachDevice, netcat and
>> xz or something combined. But that is not exactly a great solution.
>>
>> The other thing is rsyncing a single snapshot, but if I rsync several
>> they occupy the full space on the remote machine each which is also
>> less than optimal...
>>
>> Any other suggestions?
>>
>> Thanks!
>> Harald
>
> I was informed (via private mail) of the existance of btrfs send /
> receive. I'm looking into that now to see how many of the things I'd
> like to see are (or will be) covered by it!
>
> Thanks
> Harald

Hi all,

I've attempted to try out the send/receive functionality but I can't
get it to work.

I've taken a random snapshot of my laptops drive and wanted to
replicate it into a brand new btrfs volume in a VM.

On the laptop (source):
# btrfs send /snapshot | nc 10.10.10.108 4444

On the VM (receiver):
# nc -l -p 4444 | btrfs receive /mnt/restore

I'm getting the following messages on the receiving end, and an
immediate cancellation:

At subvol snapshot
receiving subvol snapshot uuid=f6c01679-a373-d74e-b0ab-2074330239bc,
stransid=3991
chown  - uid=0, gid=0
chmod  - mode=0755
utimes
ERROR: utimes  failed. Bad file descriptor

I'm running on kernel 3.8.5 on the sending side and kernel 3.8.0 on
the receiving side. btrfs-progs are from the end of January in both
cases.

I saw the code hasn't been maintained since August last year. Is it
broken or am I making some mistake??

Thanks
Harald
