Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35130 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbcBHQno (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Feb 2016 11:43:44 -0500
Received: by mail-io0-f180.google.com with SMTP id d63so200936815ioj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Feb 2016 08:43:43 -0800 (PST)
Subject: Re: suspected BTRFS errors resulting in file system becoming
 unrecovable
To: WillIam Thorne <will.thorne@me.com>
References: <525D830B-C5A6-40DC-932C-B283A7FB8932@me.com>
 <56A650AC.6050901@gmail.com> <6F3946F5-07EC-43EB-A86F-41D4E3491EDD@me.com>
Cc: linux-btrfs@vger.kernel.org, raspbian-devel@lists.alioth.debian.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56B8C574.30501@gmail.com>
Date: Mon, 8 Feb 2016 11:42:28 -0500
MIME-Version: 1.0
In-Reply-To: <6F3946F5-07EC-43EB-A86F-41D4E3491EDD@me.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-08 11:23, WillIam Thorne wrote:
> Thanks all for the help. Here’s a bit more info below. Seeing as its
> possibly related to the USB implementation on the pi, I have cc’d their
> mailing list.
Glad we could be of assistance.
>
>> On 25 Jan 2016, at 16:43, Austin S. Hemmelgarn <ahferroin7@gmail.com
>> <mailto:ahferroin7@gmail.com>> wrote:
>>
>> On 2016-01-25 09:58, WillIam Thorne wrote:
>>> Hi
>>>
>>> I have a WD 3TB external HD attached over USB to an arm based micro
>>> PC (rasp pi). I was experimenting with btrfs for storing email
>>> archives but recently encountered some problems which resulted in the
>>> filesystem becoming apparently unrecoverable. I’m not an expert and
>>> it was quicker to switch back to ext4 and restored from backup so no
>>> support needed. Here what appears to be the relevant part of the
>>> syslog including the stack trace in case it is useful:
>>>
>>> Best
>>> W
>>>
>>> pi@mail /var/log $ btrfs --version
>>> Btrfs Btrfs v0.19
>> In general, if you plan to use BTRFS on Debian (or Raspbian), you
>> should be building the tools yourself locally, Debian is almost as bad
>> about staying up to date as most enterprise distros.
>>>
>>> pi@mail /var/log $ uname -a
>>> Linux mail 4.1.7-v7+ #817 SMP PREEMPT Sat Sep 19 15:32:00 BST 2015
>>> armv7l GNU/Linux
>>>
>>> Jan 20 09:42:08 mail kernel: [2762753.507576] usb 1-1.5: reset
>>> high-speed USB device number 4 using dwc_otg
> The device reset always seemed to happen directly after my tarsnap
> <http://www.tarsnap.com/> backup ran, although this had been running
> fine for a month or so before hand. I noticed the problems when I came
> back from holiday over christmas. Maybe it’s load related, the usb
> driver / controller on the pi used to be a little buggy, maybe they
> didn’t catch everything.
If it was working correctly that long before this happened, that says 
one of two things to me:
1. It's a non-periodic intermittent error due to a design flaw or 
manufacturing defect in part of the hardware.
2. Some part of the hardware is failing.

Based on what you say below, I think the first one is the case.  Either 
way though, I would suggest you make sure you have working backups of 
any data you care about on this device, as either case is likely to 
cause data loss.
>
>>> Jan 20 09:43:18 mail kernel: [2762823.972777] sd 0:0:0:0: [sda]
>>> UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
>>> Jan 20 09:43:18 mail kernel: [2762823.972806] sd 0:0:0:0: [sda] Sense
>>> Key : 0x2 [current]
>>> Jan 20 09:43:18 mail kernel: [2762823.972819] sd 0:0:0:0: [sda]
>>> ASC=0x3a ASCQ=0x0
>>> Jan 20 09:43:18 mail kernel: [2762823.972837] sd 0:0:0:0: [sda] CDB:
>>> opcode=0x2a 2a 00 00 f7 2c 20 00 00 f0 00
>>> Jan 20 09:43:18 mail kernel: [2762823.972851] blk_update_request: I/O
>>> error, dev sda, sector 16198688
>> This line right here ^^^ indicates that it was triggered by an issue
>> with the USB device.  I don't personally know enough about USB-MSC and
>> SCSI to know for certain what is happening, but you should probably
>> scan your logs and make sure you're not still getting stuff like this,
>> because if you are, you're likely to get data corruption on any
>> filesystem on the device.  Based on this, the BTRFS trace you got is
>> probably a result of problems with the USB device.
> I reformatted the disk to ext4 on the 22nd of Jan and restored the
> backed up data in full to the disk. Since then I have grepped for
> ‘error’ and ‘dwc_otg’ in my syslog every week, but have not seen the
> errors again. I will ping an email to the list in a month or two if I am
> still not seeing these.
It may have been some design flaw in the USB device that caused it to 
not handle BTRFS write patterns well.  I've seen similar behavior with 
some really cheap SATA controllers before as well.  I'd be interested to 
see if similar issues occur with the same disk hooked up to a regular 
x86 system instead of a single-board computer like the Pi.

>>> Jan 20 09:43:18 mail kernel: [2762823.997601] BTRFS: error (device
>>> sda1) in btrfs_commit_transaction:2068: errno=-5 IO failure (Error
>>> while writing out transaction)
>>> Jan 20 09:43:18 mail kernel: [2762824.011517] BTRFS info (device
>>> sda1): forced readonly
>>> Jan 20 09:43:18 mail kernel: [2762824.011537] BTRFS warning (device
>>> sda1): Skipping commit of aborted transaction.
>>> Jan 20 09:43:18 mail kernel: [2762824.011576] ------------[ cut here
>>> ]------------
>>> Jan 20 09:43:18 mail kernel: [2762824.011682] WARNING: CPU: 0 PID:
>>> 1318 at fs/btrfs/super.c:260 __btrfs_abort_transaction+0xd8/0x128
>>> [btrfs]()
>>> Jan 20 09:43:18 mail kernel: [2762824.011709] BTRFS: Transaction
>>> aborted (error -5)
>>> Jan 20 09:43:18 mail kernel: [2762824.011717] Modules linked in:
>>> cfg80211 rfkill snd_bcm2835 snd_pcm snd_seq snd_seq_device snd_timer
>>> snd btrfs xor xor_neon raid6_pq zlib_deflate sg bcm2835_gpiomem
>>> uio_pdrv_genirq uio
>>> Jan 20 09:43:18 mail kernel: [2762824.011790] CPU: 0 PID: 1318 Comm:
>>> btrfs-transacti Not tainted 4.1.7-v7+ #817
>>> Jan 20 09:43:18 mail kernel: [2762824.011797] Hardware name: BCM2709
>>> Jan 20 09:43:18 mail kernel: [2762824.011832] [<80018440>]
>>> (unwind_backtrace) from [<80013e0c>] (show_stack+0x20/0x24)
>>> Jan 20 09:43:18 mail kernel: [2762824.011852] [<80013e0c>]
>>> (show_stack) from [<80558548>] (dump_stack+0x98/0xe0)
>>> Jan 20 09:43:18 mail kernel: [2762824.011872] [<80558548>]
>>> (dump_stack) from [<80026a4c>] (warn_slowpath_common+0x8c/0xc8)
>>> Jan 20 09:43:18 mail kernel: [2762824.011892] [<80026a4c>]
>>> (warn_slowpath_common) from [<80026ac8>] (warn_slowpath_fmt+0x40/0x48)
>>> Jan 20 09:43:18 mail kernel: [2762824.011971] [<80026ac8>]
>>> (warn_slowpath_fmt) from [<7f051790>]
>>> (__btrfs_abort_transaction+0xd8/0x128 [btrfs])
>>> Jan 20 09:43:18 mail kernel: [2762824.012153] [<7f051790>]
>>> (__btrfs_abort_transaction [btrfs]) from [<7f082a84>]
>>> (btrfs_commit_transaction+0x330/0xd40 [btrfs])
>>> Jan 20 09:43:18 mail kernel: [2762824.012353] [<7f082a84>]
>>> (btrfs_commit_transaction [btrfs]) from [<7f07e95c>]
>>> (transaction_kthread+0x174/0x1ec [btrfs])
>>> Jan 20 09:43:18 mail kernel: [2762824.012463] [<7f07e95c>]
>>> (transaction_kthread [btrfs]) from [<80042498>] (kthread+0xe8/0x104)
>>> Jan 20 09:43:18 mail kernel: [2762824.012481] [<80042498>] (kthread)
>>> from [<8000fa58>] (ret_from_fork+0x14/0x3c)
>>> Jan 20 09:43:18 mail kernel: [2762824.012492] ---[ end trace
>>> 1c48a450ca505104 ]---
>>> Jan 20 09:43:18 mail kernel: [2762824.012505] BTRFS: error (device
>>> sda1) in cleanup_transaction:1692: errno=-5 IO failure
>>> Jan 20 09:43:18 mail kernel: [2762824.022734] BTRFS info (device
>>> sda1): delayed_refs has NO entry
>> The bit about 'transaction aborted' is almost always indicative of an
>> error with the storage path (in your case, the USB controller, the USB
>> cable, or the USB device), not BTRFS.  That said, something like this
>> shouldn't usually cause the FS to be irreparably damaged, although it
>> will make the FS unusable until you remount (or possibly until you
>> reboot, I'm not certain about the error handling here because I've
>> never dealt with it myself).
>>
>> Now, just a general caution: Avoid using USB storage for persistent
>> online storage, there's just to many things that can go wrong, and
>> quite a few USB storage controllers are absolute crap.  I understand
>> that this can be somewhat tricky with something like a Raspberry Pi,
>> but with BTRFS especially, there's not sufficient error recovery in
>> Linux to safely use most USB storage devices for anything other than
>> file transfers or possibly off-line backups.  That said, there are
>> some brands that work well provided they get enough power (I've
>> personally had really good results using a SanDisk Cruzer Fit flash
>> drive (the USB 3.0 version, I've had only intermittent success with
>> the USB 2.0 ones) with a Raspberry Pi via a powered hub).
> The disk is an externally powered HD so hopefully this rules out power
> related ‘brownouts’ which I have heard can be a problem on the Pi. I’m
> just using it as a box to sling old emails on as a holding area so that
> they are out of my main email account and backed up to the cloud while
> also available to be accessed reasonably quickly if needs be.
You might consider putting a hub between the Pi and the disk itself. 
That's resolved most USB issues I've seen that weren't power related. 
If you do go this way, look for one of the ones that you could power the 
Pi itself from, those tend to be high quality.

That said, just because the device is externally powered doesn't mean it 
isn't drawing any power from the USB port, a lot of external disk 
enclosures use the external power for the disk itself, and still power 
the USB chip off the bus (this actually simplifies the hardware design 
somewhat).  I doubt that this is what was causing the issues, but it's 
still something to consider.
