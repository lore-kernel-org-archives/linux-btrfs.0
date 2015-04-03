Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39302 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbbDCVmh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Apr 2015 17:42:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ye9MI-00032j-Rr
	for linux-btrfs@vger.kernel.org; Fri, 03 Apr 2015 23:42:34 +0200
Received: from 214.102.200.146.dyn.plus.net ([146.200.102.214])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 23:42:34 +0200
Received: from just4pleisure by 214.102.200.146.dyn.plus.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 23:42:34 +0200
To: linux-btrfs@vger.kernel.org
From: Sophie Dexter <just4pleisure@gmail.com>
Subject: Re: WARNING at fs/btrfs/super.c:260 __btrfs_abort_transaction (error
 -17)
Date: Fri, 03 Apr 2015 22:42:23 +0100
Message-ID: <mfn1g0$2ij$1@ger.gmane.org>
References: <CAPmwjs9EVi-vY7FEfm+U-CYuxMms2iB-0i6mMLShdJMO6pGYjQ@mail.gmail.com>	<merpmk$m16$1@ger.gmane.org> <1427218499.30561.0@mail.thefacebook.com>	<meso51$cst$1@ger.gmane.org> <1427897630.24929.3@mail.thefacebook.com> <mfjd8k$hb0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <mfjd8k$hb0$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/04/15 13:38, Sophie Dexter wrote:
> On 01/04/2015 15:13, Chris Mason wrote:
>>
>>
>> On Tue, Mar 24, 2015 at 6:23 PM, Sophie <just4pleisure@gmail.com> wrote:
>>> On 24/03/15 17:34, Chris Mason wrote:
>>>>
>>>>
>>>> On Tue, Mar 24, 2015 at 9:43 AM, Sophie Dexter
>>>> <Just4pLeisure@gmail.com>
>>>> wrote:
>>>>> On 20/03/2015 15:19, Sophie Dexter wrote:
>>>>>> I'm given to understand that this is the right place to report a
>>>>>> btrfs
>>>>>> problem, I apologise if not :-(
>>>>>>
>>>>>> I have been using my router as a simple NFS NAS for around 2 years
>>>>>> with an ext3 formatted 2 TB Western Digital 2.5" USB Passport disk. I
>>>>>> have been slowly moving to BTRFS and thought it about time to convert
>>>>>> this disk too but unfortunately BTRFS is unreliable on my router :-(.
>>>>>> It doesn't take long for an error to happen causing a 'ro' remount.
>>>>>> However the disk is unreadable after the remount, both for NFS and
>>>>>> locally. Rebooting the router seems to be the only way to access the
>>>>>> disk again.
>>>>>>
>>>>>> I also have a 1 GB swap partition on the disk although swap doesn't
>>>>>> appear to be a factor as the problem occurs whether or not swap is
>>>>>> enabled (this report is without swap).
>>>>>>
>>>>>> I used my laptop to convert the fs to btrfs, not my router. My laptop
>>>>>> has Fedora 21 with 3.18 kernel and tools. No problems are found
>>>>>> when I
>>>>>> use my laptop to check and scrub the disk (i.e. with the disk
>>>>>> connected directly to my laptop).
>>>>
>>>> You have great timing, there are two reports of a very similar abort
>>>> with 4.0-rc5, but your report makes it clear these are not a regression
>>>> from 4.0-rc4.
>>>>
>>>> Are you able to run btrfsck on this filesystem?  I'd like to check for
>>>> metadata inconsistencies.
>>>>
>>>> -chris
>>>>
>>> Hi Chris,
>>>
>>> Haha, great timing is the secret of good comedy lol
>>>
>>> OpenWrt has only very recently signed off the 3.18 kernel as the
>>> default kernel for my router, I was using a build with 3.14 when I
>>> converted my disk and saw the same problem :!: I may have posted
>>> something I haven't repeated here in the OpenWrt ticket I opened:
>>>
>>> https://dev.openwrt.org/ticket/19216
>>>
>>> I previously checked and scrubbed the disk when the problem first
>>> occurred and happily no problems were found then. Although, I had to
>>> use another computer because btrfs check doesn't complete on my
>>> router, the process is killed due to lack of memory (btrfs invoked
>>> oom-killer) :-( Should I start another topic for this or just accept
>>> that that problem is due to a lack of memory?
>>>
>>> I have just run btrfs check again using (yet another) laptop and I
>>> think everything is still OK:
>>>
>>> # btrfs check /dev/sdb1
>>> Checking filesystem on /dev/sdb1
>>> UUID: ########-####-####-####-############
>>> checking extents
>>> checking free space cache
>>> checking fs roots
>>> checking csums
>>> checking root refs
>>> found 930516788539 bytes used err is 0
>>> total csum bytes: 1234353920
>>> total tree bytes: 1458515968
>>> total fs tree bytes: 54571008
>>> total extent tree bytes: 66936832
>>> btree space waste bytes: 73372568
>>> file data blocks allocated: 1264250781696
>>>  referenced 1264250781696
>>> Btrfs v3.14.1
>>> # uname -a
>>> Linux ######-########-#### 3.16.0-31-generic #43-Ubuntu SMP Tue Mar 10
>>> 17:37:36 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>>
>> Sophie, can you please grab the latest btrfs progs from git:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
>>
>> And try with that btrfsck?
>>
>> The other image that is reproducing this has an error in the free space
>> cache, so I'd like to confirm if you're hitting the same problem.
>>
>> -chris
>>
> Hi Chris,
>
> I compiled the tools on my Fedora laptop this lunchtime (and noticed a
> few omissions on the btrfs wiki source repositories page so have
> requested a wiki account so that I can update that page). I don't have
> the problematic disk with me at the moment but will btrfsck it again
> when I get home.
>
> Is it helpful to test my disk with different systems? I could build the
> latest tools on my Ubuntu laptop and I see that OpenWRT updated to
> 3.19.1 btrfs progs a few days ago too. I will try them on my router
> anyway to see if btrfsck now completes or if the oom-killer steps in still.
>
> I don't know what version of tools are on my Raspbian Raspberry Pi but
> if they're not the new ones I could try to (cross?) compile those to,
> but tthat might take me a little while as I haven't compiled anything
> for my Raspberry Pi before.
>
> Happy Easter :-)
> Sophie x
>
Hi Chris,

I first tested my disk on my Kubuntu laptop with the btrfs-progs that I 
built from git and everything looked good

Next I tested on my router using btrfs-progs from OpenWrt nightly 
builds. My first attempt to run btrfsck failed because of lack of memory 
(oom-killer) so I mounted a 1GiB swap partition and tried again. This 
time btrfsck got further but appeared to find a problem with the free 
space cache - eek :-(

BUT, I retested on my Kubuntu laptop and then my Fedora laptop and there 
are no errors ?!?

Finally I ran btrfsck using my Raspberry Pi 2 and again no problems 
detected although the version of btrfs-tools on my Raspberry Pi, v0.19, 
appears rather unusual to me.

So, whilst the problem, as indicated on my router at least, may be 
related to the free space cache, it doesn't appear to be entirely real. 
The only other observation I made is that btrfsck on my RPi indicates a 
different number of found bytes used.

Hopefully you can infer something from my findings,
Sophie x

My 1st test, using my Kubuntu laptop:

$ uname -a
Linux ######-########-#### 3.16.0-31-generic #43-Ubuntu SMP Tue Mar 10 
17:37:36 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

$ ./btrfs --version
btrfs-progs v3.19.1

$ sudo ./btrfsck /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: ########-####-####-####-############
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 1265436922895 bytes used err is 0
total csum bytes: 1234353920
total tree bytes: 1458507776
total fs tree bytes: 54571008
total extent tree bytes: 66928640
btree space waste bytes: 73338086
file data blocks allocated: 1264250781696
  referenced 1264250781696
btrfs-progs v3.19.1

2nd test, using my router:

# uname -a
Linux ######### 3.18.9 #1 Thu Mar 19 18:35:47 UTC 2015 mips GNU/Linux

# btrfs --version
btrfs-progs v3.19.1

# btrfsck /dev/sda1
Warning, could not drop caches
Warning, could not drop caches
Checking filesystem on /dev/sda1
UUID: ########-####-####-####-############
checking extents
checking free space cache
btrfs: unable to add free space :-17
btrfsck: free-space-cache.c: 806: btrfs_add_free_space: Assertion `!(ret 
== -17)' failed.
Aborted

3rd test, using my Fedora laptop

# uname -a
Linux #####-######.########.### 3.19.1-201.fc21.x86_64 #1 SMP Wed Mar 18 
04:29:24 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

# ./btrfs --version
btrfs-progs v3.19.1

# ./btrfsck /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: ########-####-####-####-############
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 1265436922895 bytes used err is 0
total csum bytes: 1234353920
total tree bytes: 1458507776
total fs tree bytes: 54571008
total extent tree bytes: 66928640
btree space waste bytes: 73338086
file data blocks allocated: 1264250781696
  referenced 1264250781696
btrfs-progs v3.19.1

4th test, using my Raspberry Pi 2:

$ uname -a
Linux raspberrypi 3.18.10-v7+ #774 SMP PREEMPT Wed Mar 25 14:10:30 GMT 
2015 armv7l GNU/Linux

$ btrfs --version
Btrfs Btrfs v0.19

$ sudo btrfsck /dev/sda1
checking extents
checking fs roots
checking root refs
found 1265709289472 bytes used err is 0
total csum bytes: 1234353920
total tree bytes: 1458507776
total fs tree bytes: 54571008
btree space waste bytes: 73338086
file data blocks allocated: 1264250781696
  referenced 1264250781696
Btrfs Btrfs v0.19

