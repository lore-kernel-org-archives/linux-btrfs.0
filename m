Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:45868 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760724Ab3DCCdo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 22:33:44 -0400
Received: by mail-lb0-f177.google.com with SMTP id r10so1094694lbi.22
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2013 19:33:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFWF=a=iuvwUdSe7JuH3fMF1vugv4J90nV2D2cZV0E_LXj8RWQ@mail.gmail.com>
References: <CAFWF=ak8pDRocvUgWuTHK+6SCOoCiuNAbhY_FNwwifsT+u6VHw@mail.gmail.com>
 <CAFWF=ak0uG-7_zka6WSSztRnVBESsnB+M+ia1fXi5Ncm3nGOQA@mail.gmail.com> <CAFWF=a=iuvwUdSe7JuH3fMF1vugv4J90nV2D2cZV0E_LXj8RWQ@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Wed, 3 Apr 2013 04:33:22 +0200
Message-ID: <CAFWF=annpxTBF2_E=LThnqvc942ov=7ivBBqvDGDfci8haMWSA@mail.gmail.com>
Subject: Re: Backup Options
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 3, 2013 at 4:23 AM, Harald Glatt <mail@hachre.de> wrote:
> On Wed, Apr 3, 2013 at 1:29 AM, Harald Glatt <mail@hachre.de> wrote:
>> On Tue, Apr 2, 2013 at 7:37 PM, Harald Glatt <mail@hachre.de> wrote:
>>> Hi list,
>>>
>>> what are currently the backup options for btrfs?
>>>
>>> Is it possible to somehow duplicate the entire filesystem including
>>> all snapshots without using the real space for each snapshot onto a
>>> remote server? (Maybe given the remote server uses btrfs too?) Are
>>> these features planned?
>>>
>>> Right now the only solution I know of is dd if=eachDevice, netcat and
>>> xz or something combined. But that is not exactly a great solution.
>>>
>>> The other thing is rsyncing a single snapshot, but if I rsync several
>>> they occupy the full space on the remote machine each which is also
>>> less than optimal...
>>>
>>> Any other suggestions?
>>>
>>> Thanks!
>>> Harald
>>
>> I was informed (via private mail) of the existance of btrfs send /
>> receive. I'm looking into that now to see how many of the things I'd
>> like to see are (or will be) covered by it!
>>
>> Thanks
>> Harald
>
> Hi all,
>
> I've attempted to try out the send/receive functionality but I can't
> get it to work.
>
> I've taken a random snapshot of my laptops drive and wanted to
> replicate it into a brand new btrfs volume in a VM.
>
> On the laptop (source):
> # btrfs send /snapshot | nc 10.10.10.108 4444
>
> On the VM (receiver):
> # nc -l -p 4444 | btrfs receive /mnt/restore
>
> I'm getting the following messages on the receiving end, and an
> immediate cancellation:
>
> At subvol snapshot
> receiving subvol snapshot uuid=f6c01679-a373-d74e-b0ab-2074330239bc,
> stransid=3991
> chown  - uid=0, gid=0
> chmod  - mode=0755
> utimes
> ERROR: utimes  failed. Bad file descriptor
>
> I'm running on kernel 3.8.5 on the sending side and kernel 3.8.0 on
> the receiving side. btrfs-progs are from the end of January in both
> cases.
>
> I saw the code hasn't been maintained since August last year. Is it
> broken or am I making some mistake??
>
> Thanks
> Harald

Once I had sent the previous mail I noticed that had accidentially
lied about the command on the receiver side:
# nc -l -p 4444 | btrfs receive /mnt/restore

However what I actually did was:
# cd /mnt/restore
# nc -l -p 4444 | btrfs receive .

After noticing this difference I had to try it again as described in
my mail and - oh wonder - it works now!! Giving 'btrfs receive' a dot
as a parameter seems to fail in this case. Is this expected behavior
or a bug?

Anyway I fixed my own problem and I'll continue trying the send /
receive out. Sorry for the trouble :)

Thanks!
Harald
