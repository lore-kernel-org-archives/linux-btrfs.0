Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35605 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbbJ0Oac (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 10:30:32 -0400
Received: by pasz6 with SMTP id z6so224191774pas.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 07:30:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+9GZUioamT+urUtZRvyv-hkurDpqH8A_f-L9ge9nUsq_tL=8w@mail.gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <562E37F4.9080602@oracle.com> <CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
 <CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
 <CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
 <CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
 <CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com>
 <562F638B.1040701@gmail.com> <BLU436-SMTP2188EE1DBF30D4E50D6F3DA9220@phx.gbl>
 <562F7C7B.6060408@gmail.com> <CA+9GZUg3LxLqdqUATHVyLMsDYkH1FfvawtGZgKAv46qNsuZ-xQ@mail.gmail.com>
 <CA+9GZUioamT+urUtZRvyv-hkurDpqH8A_f-L9ge9nUsq_tL=8w@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Tue, 27 Oct 2015 15:30:12 +0100
Message-ID: <CA+9GZUhXfVyJd9CKb2RSms4g6YQUue+z7N54+=SKUmzrwqg4xw@mail.gmail.com>
Subject: Re: Bad fs performance, IO freezes
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Henk Slager <hslager@hotmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Feel free to suggest a good 1.5m USB3 cable, too. Let's get rid of all
the unknowns.

On Tue, Oct 27, 2015 at 3:26 PM, cheater00 . <cheater00@gmail.com> wrote:
> If you can suggest a dual (or better yet quad) USB3 bay that can be
> bought on Amazon, I'll buy it now, and once that arrives, we can be
> sure it's not the JMicron chipset.
>
> On Tue, Oct 27, 2015 at 3:22 PM, cheater00 . <cheater00@gmail.com> wrote:
>> The (dual) HDD bay and the chipset are, according to lsusb:
>> Bus 002 Device 005: ID 152d:0551 JMicron Technology Corp. / JMicron
>> USA Technology Corp.
>> Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
>>
>> Not sure how to find out specific model numbers? I could open up the
>> bay. OK I'll open up the bay.
>> Good thing I have just the right screwdriver. It's a JMS551, and just
>> for records sake, here's the manufacture info:
>>
>> JMS551
>> 1120 LGAA2 A
>> 572QV0024
>>
>> The laptop manual says it's either "Intel HM65 Express chipset with
>> NEC USB 3.0 (select models only)" or "Intel HM65 Express chipset".
>> Here are technical documents for my model:
>> Manual: http://docdro.id/hG627JM
>> "Intel chipset datasheet": http://docdro.id/yKRupYO
>> Service guide: http://docdro.id/AuDgUdE
>> Service guide, alt. ver.: http://docdro.id/WwQRpsH
>>
>> FWIW I'm using one of the USB3 ports on the left. The ones on the
>> right are USB2.
>>
>> I've never used docdro.id so if it's not good let me know where to
>> upload the PDFs to.
>>
>> autodefrag is on, yes. But I have been having issues before turning it
>> on - I turned it on as a measure towards fixing the issues. I will
>> turn it off and remount, then report. But I don't think that should be
>> it. As you see the transfer speeds are minimal. They're *all* that's
>> happening on the disk. Right now that's under 100 KB/sec and I'm still
>> getting freezes albeit less. Also why would I be getting freezes when
>> the transfer speeds jump up - just for them to drop again? Hmm, maybe
>> utorrent has some sort of scheduler that gets preempted while the
>> spike is happening, and some algorithm in it gets the wrong idea and
>> turns some sort of flow control on, because it thinks it's hit some
>> sort of physical transfer speed barrier. Also notice the upload and
>> download both scale together, but that just might be how torrent
>> works, maybe it just tries to be fair i.e. only uploads as much as it
>> downloaded (scaled by a constant).
>>
>> The system is 32 bit because I installed ubuntu 6 one day and just
>> kept on upgrading. I keep on telling myself I'll update to 64 bits,
>> one of these days. But this laptop only has 8 gigs of ram, so no real
>> reason to upgrade to 64 bit anyways. It's not like I need firefox to
>> be able to eat 8 gb of ram whereas right now it can only eat 4. There
>> is no simple upgrade path that I know of so it's either a fresh
>> install or doing something like this: http://www.ewan.cc/?q=node/132
>> -- I keep telling myself /one of these days/...
>>
>> On Tue, Oct 27, 2015 at 2:30 PM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> On 2015-10-27 09:00, Henk Slager wrote:
>>>>
>>>> I don't have a lot experience with autodefrag, but as indicated by
>>>> Austin, expect a lot of full rewrites of files that are relatively
>>>> slowly filled up by a torrent client, starting with a sparse file. So
>>>> 1st advice would be to remove this option and run it as crontask at
>>>> particular times.
>>>>
>>>> What SATA-USB bridge is between the harddisk and the PC motherboard ?
>>>
>>> I hadn't thought of this, but the specific adapter being used for the disk
>>> can have a lot of impact on how it preforms.  I've personally had lots of
>>> issues with JMicron chipsets (ranging from latency issues like what you are
>>> seeing to sever data corruption), but have found that ASMedia ones tend to
>>> be pretty much rock solid reliable and have good performance (although I
>>> think they only do USB 3.0 adapters).
>>>>
>>>> Also what USB host chipset is on the PC motherboard ?
>>>
>>> If it's a Intel motherboard, the USB 2.0 ports are probably routed through
>>> on-board hubs to the ports provided by whatever Intel calls their equivalent
>>> of the south bridge these days, and the USB 3.0 ports are probably a mix of
>>> Intel and ASMedia XHCI controllers (ASMedia was one of the first companies
>>> to do an inexpensive standalone XHCI chip, so they're relatively popular for
>>> extra USB 3.0 ports).  FWIW, the first generation of Intel XHCI chips had
>>> some issues with older Linux kernels, although IIRC those issues were along
>>> the lines of a port just disappearing after disconnecting whatever was
>>> connected to it.
>>>>
>>>> Why don't you run 64-bit Ubuntu on this core i7 ?
>>>
>>> 64 versus 32 bit shouldn't cause anything like this to happen (although, if
>>> it can be proven that it does, then that is a serious bug that needs to be
>>> fixed).  That said, unless you have some desperate need to be running 32-bit
>>> only, you should seriously look into updating to a 64-bit version, your
>>> whole system should run faster, and Ubuntu has really good 32-bit
>>> compatibility in the 64-bit version (which is part of why it's popular as a
>>> support target for third party software like Steam).
>>>
>>>>
>>>>
>>>> On Tue, Oct 27, 2015 at 12:44 PM, Austin S Hemmelgarn
>>>> <ahferroin7@gmail.com> wrote:
>>>>>
>>>>> On 2015-10-26 22:00, cheater00 . wrote:
>>>>>>
>>>>>>
>>>>>> Hello,
>>>>>> currently my computer freezes every several seconds for half a second
>>>>>> or so. Using it feels like I'm playing musical chairs with the kernel.
>>>>>> I have just one download happening on utorrent right now - this is
>>>>>> what the graph looks like:
>>>>>> http://i.imgur.com/LqhMtrJ.png
>>>>>> and every time a new spike happens, a freeze happens just before
>>>>>> that... that's the only time those freezes happen, too.
>>>>>>
>>>>> Do you have the 'autodefrag' mount option enabled?  If it is turned on,
>>>>> then
>>>>> that may be the problem.  Most bittorrent clients pre-allocate the space
>>>>> for
>>>>> a download, then write each block directly into the location it's
>>>>> supposed
>>>>> to be in the resultant download, which means depending on how it's
>>>>> pre-allocating the space, that you end up with a large number of randomly
>>>>> ordered writes into a single file, which in turn will trigger the
>>>>> autodefrag
>>>>> code, which can cause latency spikes when you're also hitting the disk at
>>>>> the same time.
>>>
>>>
>>>
