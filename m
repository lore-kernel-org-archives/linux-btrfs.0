Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33871 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbJ2NDt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 09:03:49 -0400
Received: by padhk11 with SMTP id hk11so40784804pad.1
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 06:03:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <562F97B5.8000108@gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <562E37F4.9080602@oracle.com> <CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
 <CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
 <CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
 <CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
 <CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com>
 <562F638B.1040701@gmail.com> <BLU436-SMTP2188EE1DBF30D4E50D6F3DA9220@phx.gbl>
 <562F7C7B.6060408@gmail.com> <CA+9GZUg3LxLqdqUATHVyLMsDYkH1FfvawtGZgKAv46qNsuZ-xQ@mail.gmail.com>
 <CA+9GZUioamT+urUtZRvyv-hkurDpqH8A_f-L9ge9nUsq_tL=8w@mail.gmail.com>
 <CA+9GZUhXfVyJd9CKb2RSms4g6YQUue+z7N54+=SKUmzrwqg4xw@mail.gmail.com>
 <CA+9GZUhtS9Y-711VSaS1-ie92x9FtZFHw5WZ5__+YgbGneU9kA@mail.gmail.com> <562F97B5.8000108@gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Thu, 29 Oct 2015 14:03:28 +0100
Message-ID: <CA+9GZUhKmH9x_D6r=P8p=E4H38t+jcUQd1bFeVeE_uj1GyTA8A@mail.gmail.com>
Subject: Re: Bad fs performance, IO freezes
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, Liu Bo <bo.li.liu@oracle.com>
Cc: Henk Slager <hslager@hotmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,
after talking with Holger I believe turning off COW on this FS will
work to alleviate this issue. However, even with COW on, btrfs
shouldn't be making my computer freeze every 5 seconds... especially
while the disk is written to at mere tens of kilobytes per second.
It's not even the disk holding the system. I consider this a pretty
bad bug... should we go on with trying to reproduce a minimum case?
How would I go about this?

Thanks

On Tue, Oct 27, 2015 at 4:26 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-10-27 10:43, cheater00 . wrote:
>>
>> I have remounted without autodefrag and the issue keeps on happening.
>
> OK, that at least narrows things down further.  My guess is the spikes are
> utorrent getting a bunch of blocks at once from one place, and then trying
> to write all of them at the same time, which could theoretically cause a
> latency spike on any filesystem, and BTRFS may just be making it worse.
>>
>>
>> On Tue, Oct 27, 2015 at 3:30 PM, cheater00 . <cheater00@gmail.com> wrote:
>>>
>>> Feel free to suggest a good 1.5m USB3 cable, too. Let's get rid of all
>>> the unknowns.
>
> When it comes to external cables, I've had really good success with Amazon's
> 'Amazon Basics' branded stuff.  It's usually some of the best quality you
> can find for the price.  The 'Cable Matters' and 'Pluggable' brands also
> tend to be really good quality for the price.
>>>
>>> On Tue, Oct 27, 2015 at 3:26 PM, cheater00 . <cheater00@gmail.com> wrote:
>>>>
>>>> If you can suggest a dual (or better yet quad) USB3 bay that can be
>>>> bought on Amazon, I'll buy it now, and once that arrives, we can be
>>>> sure it's not the JMicron chipset.
>
> I don't really have any suggestions here.  Usually when I hook up an
> external drive, it's to recover data from a friends computer, so I don't
> typically use a enclosure, but just use a simple adapter cable.  I would
> suggest looking for one advertising 'UAS' or 'UASP' support, as that's a
> relatively new standard for USB storage devices, and newer hardware should
> be more reliable.  It's also notoriously hard to determine what chipset a
> given model of external drive bay has (there are people I know who bought
> multiples of the same model and each one had a different chipset
> internally), and to complicate matters, quite often the exact same hardware
> gets marketed under half a dozen different names.  JMicron is popular
> because their chips are comparatively inexpensive, and while I've not had
> good results with them, that doesn't mean that they are all bad (especially
> considering that they are highly configurable based on how they are wired
> into the device, and not everyone who designs hardware around them properly
> understands the implications of some of the features).
>>>>
>>>>
>>>> On Tue, Oct 27, 2015 at 3:22 PM, cheater00 . <cheater00@gmail.com>
>>>> wrote:
>>>>>
>>>>> The (dual) HDD bay and the chipset are, according to lsusb:
>>>>> Bus 002 Device 005: ID 152d:0551 JMicron Technology Corp. / JMicron
>>>>> USA Technology Corp.
>>>>> Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
>>>>>
>>>>> Not sure how to find out specific model numbers? I could open up the
>>>>> bay. OK I'll open up the bay.
>>>>> Good thing I have just the right screwdriver. It's a JMS551, and just
>>>>> for records sake, here's the manufacture info:
>>>>>
>>>>> JMS551
>>>>> 1120 LGAA2 A
>>>>> 572QV0024
>>>>>
>>>>> The laptop manual says it's either "Intel HM65 Express chipset with
>>>>> NEC USB 3.0 (select models only)" or "Intel HM65 Express chipset".
>>>>> Here are technical documents for my model:
>>>>> Manual: http://docdro.id/hG627JM
>>>>> "Intel chipset datasheet": http://docdro.id/yKRupYO
>>>>> Service guide: http://docdro.id/AuDgUdE
>>>>> Service guide, alt. ver.: http://docdro.id/WwQRpsH
>
> From what I can tell, you've got the one with the NEC USB 3.0 chip, I'm
> pretty cure that the HM65 doesn't have USB 3.0 itself.  FWIW, I've never
> personally had issues with NEC's USB 3.0 chips, but I've not had much
> experience using systems with them either.
>>>>>
>>>>>
>>>>> FWIW I'm using one of the USB3 ports on the left. The ones on the
>>>>> right are USB2.
>>>>>
>>>>> I've never used docdro.id so if it's not good let me know where to
>>>>> upload the PDFs to.
>>>>>
>>>>> autodefrag is on, yes. But I have been having issues before turning it
>>>>> on - I turned it on as a measure towards fixing the issues. I will
>>>>> turn it off and remount, then report. But I don't think that should be
>>>>> it. As you see the transfer speeds are minimal. They're *all* that's
>>>>> happening on the disk. Right now that's under 100 KB/sec and I'm still
>>>>> getting freezes albeit less. Also why would I be getting freezes when
>>>>> the transfer speeds jump up - just for them to drop again? Hmm, maybe
>>>>> utorrent has some sort of scheduler that gets preempted while the
>>>>> spike is happening, and some algorithm in it gets the wrong idea and
>>>>> turns some sort of flow control on, because it thinks it's hit some
>>>>> sort of physical transfer speed barrier. Also notice the upload and
>>>>> download both scale together, but that just might be how torrent
>>>>> works, maybe it just tries to be fair i.e. only uploads as much as it
>>>>> downloaded (scaled by a constant).
>
> Yeah, utorrent defaults to trying for a 1:1 ratio of uploads to downloads
> (so in terms of viewing the group of clients downloading a torrent as a
> network, it defaults to contributing as much bandwidth as it uses).  This is
> pretty typical behavior for most torrent clients, and in fact downloading
> more than you upload for a torrent is generally considered bad etiquette.
>>>>>
>>>>>
>>>>> The system is 32 bit because I installed ubuntu 6 one day and just
>>>>> kept on upgrading. I keep on telling myself I'll update to 64 bits,
>>>>> one of these days. But this laptop only has 8 gigs of ram, so no real
>>>>> reason to upgrade to 64 bit anyways. It's not like I need firefox to
>>>>> be able to eat 8 gb of ram whereas right now it can only eat 4. There
>>>>> is no simple upgrade path that I know of so it's either a fresh
>>>>> install or doing something like this: http://www.ewan.cc/?q=node/132
>>>>> -- I keep telling myself /one of these days/...
>
> That's entirely understandable.  It's never been easy to do an in-place
> upgrade from 32 to 64 bit.  It's worth noting that while it's not easy to do
> a full upgrade to 64-bit, it is relatively easy to run a 32-bit userspace on
> a 64-bit kernel (at least, it should be, it's been so long since I used
> Ubuntu for anything that I really don't have much frame of reference
> regarding it beyond the fact that it's based on Debian).
>
>>>>>
>>>>> On Tue, Oct 27, 2015 at 2:30 PM, Austin S Hemmelgarn
>>>>> <ahferroin7@gmail.com> wrote:
>>>>>>
>>>>>> On 2015-10-27 09:00, Henk Slager wrote:
>>>>>>>
>>>>>>>
>>>>>>> I don't have a lot experience with autodefrag, but as indicated by
>>>>>>> Austin, expect a lot of full rewrites of files that are relatively
>>>>>>> slowly filled up by a torrent client, starting with a sparse file. So
>>>>>>> 1st advice would be to remove this option and run it as crontask at
>>>>>>> particular times.
>>>>>>>
>>>>>>> What SATA-USB bridge is between the harddisk and the PC motherboard ?
>>>>>>
>>>>>>
>>>>>> I hadn't thought of this, but the specific adapter being used for the
>>>>>> disk
>>>>>> can have a lot of impact on how it preforms.  I've personally had lots
>>>>>> of
>>>>>> issues with JMicron chipsets (ranging from latency issues like what
>>>>>> you are
>>>>>> seeing to sever data corruption), but have found that ASMedia ones
>>>>>> tend to
>>>>>> be pretty much rock solid reliable and have good performance (although
>>>>>> I
>>>>>> think they only do USB 3.0 adapters).
>>>>>>>
>>>>>>>
>>>>>>> Also what USB host chipset is on the PC motherboard ?
>>>>>>
>>>>>>
>>>>>> If it's a Intel motherboard, the USB 2.0 ports are probably routed
>>>>>> through
>>>>>> on-board hubs to the ports provided by whatever Intel calls their
>>>>>> equivalent
>>>>>> of the south bridge these days, and the USB 3.0 ports are probably a
>>>>>> mix of
>>>>>> Intel and ASMedia XHCI controllers (ASMedia was one of the first
>>>>>> companies
>>>>>> to do an inexpensive standalone XHCI chip, so they're relatively
>>>>>> popular for
>>>>>> extra USB 3.0 ports).  FWIW, the first generation of Intel XHCI chips
>>>>>> had
>>>>>> some issues with older Linux kernels, although IIRC those issues were
>>>>>> along
>>>>>> the lines of a port just disappearing after disconnecting whatever was
>>>>>> connected to it.
>>>>>>>
>>>>>>>
>>>>>>> Why don't you run 64-bit Ubuntu on this core i7 ?
>>>>>>
>>>>>>
>>>>>> 64 versus 32 bit shouldn't cause anything like this to happen
>>>>>> (although, if
>>>>>> it can be proven that it does, then that is a serious bug that needs
>>>>>> to be
>>>>>> fixed).  That said, unless you have some desperate need to be running
>>>>>> 32-bit
>>>>>> only, you should seriously look into updating to a 64-bit version,
>>>>>> your
>>>>>> whole system should run faster, and Ubuntu has really good 32-bit
>>>>>> compatibility in the 64-bit version (which is part of why it's popular
>>>>>> as a
>>>>>> support target for third party software like Steam).
>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On Tue, Oct 27, 2015 at 12:44 PM, Austin S Hemmelgarn
>>>>>>> <ahferroin7@gmail.com> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2015-10-26 22:00, cheater00 . wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hello,
>>>>>>>>> currently my computer freezes every several seconds for half a
>>>>>>>>> second
>>>>>>>>> or so. Using it feels like I'm playing musical chairs with the
>>>>>>>>> kernel.
>>>>>>>>> I have just one download happening on utorrent right now - this is
>>>>>>>>> what the graph looks like:
>>>>>>>>> http://i.imgur.com/LqhMtrJ.png
>>>>>>>>> and every time a new spike happens, a freeze happens just before
>>>>>>>>> that... that's the only time those freezes happen, too.
>>>>>>>>>
>>>>>>>> Do you have the 'autodefrag' mount option enabled?  If it is turned
>>>>>>>> on,
>>>>>>>> then
>>>>>>>> that may be the problem.  Most bittorrent clients pre-allocate the
>>>>>>>> space
>>>>>>>> for
>>>>>>>> a download, then write each block directly into the location it's
>>>>>>>> supposed
>>>>>>>> to be in the resultant download, which means depending on how it's
>>>>>>>> pre-allocating the space, that you end up with a large number of
>>>>>>>> randomly
>>>>>>>> ordered writes into a single file, which in turn will trigger the
>>>>>>>> autodefrag
>>>>>>>> code, which can cause latency spikes when you're also hitting the
>>>>>>>> disk at
>>>>>>>> the same time.
>
>
>
