Return-Path: <SRS0=vUl+=QK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB49C169C4
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Feb 2019 05:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EEEE2083B
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Feb 2019 05:40:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="ZPsgQ/45";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gehpyHT9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfBCFkI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 3 Feb 2019 00:40:08 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39273 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725648AbfBCFkI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Feb 2019 00:40:08 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 3E0BE21B0E;
        Sun,  3 Feb 2019 00:40:04 -0500 (EST)
Received: from imap2 ([10.202.2.52])
  by compute5.internal (MEProxy); Sun, 03 Feb 2019 00:40:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        message-id:in-reply-to:references:date:from:to:subject
        :content-type; s=fm2; bh=x92usV+Eg4/RlST3Ld3JtS2RTmhRqG46mkig1cC
        P6nk=; b=ZPsgQ/4544Y85qjDF7T/1+pOM7aIraobqIXfuN/aIR6dswkoSo0O7cV
        MCpKlZslQPAgO7R5unLcdw/4PpF6qkOpnWH8oJNmIOzL7lJWZA0WFs6h5DBChWva
        YUBxN1u/S4wbIC/Xx/22qnHI+Hy9qgWOluu31Qz7yxTgW7TfIe5cGpdDxvvAhrCf
        YwPZZCKL2FENxNGehOOliC2/Sez+SjRsrZOtd0K7PtqTsZCBlIKq88pw33IO28Jq
        hTvzIEGfG75ppd2BYYRGs/NpxD7Zt3Vq1u90of/NiubuhaZqrhOIDCb8zC2iA3mc
        GLfF/K9ui/BuwJAwldmzJRa0zgREA5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:references:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=x92usV+Eg4/RlST3L
        d3JtS2RTmhRqG46mkig1cCP6nk=; b=gehpyHT9Cr3VNksRMg88reZN2/Eg6Ch8z
        iRbWPLcgz71aFtcw1Me1EcDRDcC7AhWekm6OdtYmDeyNVmwtB4AeSahQIHiS018o
        Nlm03a9J/fr6LtZD9IX0IHYvQF1E1IquTeWoC88ob0el3w8Ob24gjb8fDgFuQIdX
        v8Ktat4g4V0VTyuYf101au5SRcOCtQxSpV5fJkccypzriCMN0Ebl2Qx5sW/ltqbO
        B3DeVk76zwrykDGUFISrqhevDBWWme52so9Xej0jSm3Pf95ZvUXpAMXCiRfmg/uA
        NIguE5TbX7iHr/GifMauUorLju2JCa+iLAEVafBUoUHz2XEaB3Krg==
X-ME-Sender: <xms:s35WXDt9A-Q6ysRZ7RnhOIz4QV6F6YQe9qqYMzz9PFg1iXZWrF9zyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrkedugdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecufedt
    tdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepofgfkfgjfhffhf
    fvufgtsehmtderreerredtnecuhfhrohhmpedftehlrghnucfjrghrughmrghnfdcuoegr
    lhgrnhhhsehfrghsthhmrghilhdrtghomheqnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgrnhhhsehfrghsthhmrghilhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:s35WXMqmK6NJQZmc70eHuD1D8fx9uiwF13ptMW7_LfrFCMP1vBMoSg>
    <xmx:s35WXOGR8J5LyYljcY6R7RZrtMCk_mCU-bvTeH2HvRiGoADK-2YWsA>
    <xmx:s35WXP5o27j5yGwPixCCzCIH-XCYT8eKvfhg5PXTiljlTXiq1XDKsw>
    <xmx:tH5WXB6rJ9ZvKHNC4oiOYKRYJEcCdNhdIa8IUyOQIJJkYc2cQEcZuA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C3B6A7C2C4; Sun,  3 Feb 2019 00:40:03 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.5-832-gba113d7-fmstable-20190201v1
X-Me-Personality: 68176920
Message-Id: <276ebe4c-2d16-4850-8aa1-32794f3f2502@www.fastmail.com>
In-Reply-To: <CAJCQCtRL4bd+2_g8+YZ5uV254E_nK3OxS9Q0AB5dqN-N4zcd0Q@mail.gmail.com>
References: <4ef8b545-efa8-43b0-8576-78c71bfb0e2c@www.fastmail.com>
 <20190202120149.GE4461@carfax.org.uk>
 <CAJCQCtRL4bd+2_g8+YZ5uV254E_nK3OxS9Q0AB5dqN-N4zcd0Q@mail.gmail.com>
Date:   Sun, 03 Feb 2019 00:40:02 -0500
From:   "Alan Hardman" <alanh@fastmail.com>
To:     "Hugo Mills" <hugo@carfax.org.uk>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>,
        "Chris Murphy" <lists@colorremedies.com>
Subject: Re: RAID1 filesystem not mounting
Content-Type: multipart/mixed;
 boundary=f186eda459244226b190407c0970b6f5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--f186eda459244226b190407c0970b6f5
Content-Type: text/plain

Thanks for the quick response, Chris and Hugo!

After some testing, there *was* a RAM issue that has now been resolved, so that should prevent it from being a factor going forward, but could definitely have been related. The high number of lifetime errors for the filesystem is expected, and isn't related to this issue; it was caused by a bad power supply that caused a disk to go completely offline during a balance operation, but was fully recovered via scrub and hasn't shown any increase in errors since then until this new issue (going several months without an error, several TB written).

I've attached full output from Chris's recommendations, here are a couple excerpts:

# btrfs rescue super -v /dev/sdb
...
All supers are valid, no need to recover

# journalctl | grep -A 15 exception
...
Jan 23 01:06:37 localhost kernel: ata3.00: status: { DRDY }
Jan 23 01:06:37 localhost kernel: ata3.00: failed command: WRITE FPDMA QUEUED
Jan 23 01:06:37 localhost kernel: ata3.00: cmd 61/b0:98:ea:7a:48/00:00:0a:00:00/40 tag 19 ncq dma 90112 out
                                           res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
--
Jan 31 19:24:32 localhost kernel: ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Jan 31 19:24:32 localhost kernel: ata5.00: failed command: READ DMA EXT
Jan 31 19:24:32 localhost kernel: ata5.00: cmd 25/00:08:a8:2a:81/00:00:a3:03:00/e0 tag 0 dma 4096 in
                                           res 40/00:01:00:00:00/00:00:00:00:00/10 Emask 0x4 (timeout)
Jan 31 19:24:32 localhost kernel: ata5.00: status: { DRDY }
Jan 31 19:24:32 localhost kernel: ata5: link is slow to respond, please be patient (ready=0)
Jan 31 19:24:32 localhost kernel: ata5: device not ready (errno=-16), forcing hardreset
Jan 31 19:24:32 localhost kernel: ata5: soft resetting link
Jan 31 19:24:32 localhost kernel: ata5.00: configured for UDMA/33
Jan 31 19:24:32 localhost kernel: ata5.01: configured for UDMA/33
Jan 31 19:24:32 localhost kernel: sd 4:0:0:0: [sde] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 31 19:24:32 localhost kernel: sd 4:0:0:0: [sde] tag#0 Sense Key : Illegal Request [current]
Jan 31 19:24:32 localhost kernel: sd 4:0:0:0: [sde] tag#0 Add. Sense: Unaligned write command
Jan 31 19:24:32 localhost kernel: sd 4:0:0:0: [sde] tag#0 CDB: Read(16) 88 00 00 00 00 03 a3 81 2a a8 00 00 00 08 00 00

This last journalctl result was from the first system boot when the filesystem stopped being mountable. The filesystem had been remounted as read-only automatically after a few errors (see btrfs-journal.log in archive). None of my other system log files were relevant from what I could tell, so I limited this to journalctl's output.

I have been able to successfully recover files via "btrfs restore ...", and there doesn't seem to be anything essential missing from its full output with -D, so if that's necessary to use to offload the entire filesystem, it at least seems possible if it can't be recovered directly.

Thanks for the help!

On Sat, Feb 2, 2019, at 17:26, Chris Murphy wrote:
> On Sat, Feb 2, 2019 at 5:02 AM Hugo Mills <hugo@carfax.org.uk> wrote:
> >
> > On Fri, Feb 01, 2019 at 11:28:27PM -0500, Alan Hardman wrote:
> > > I have a Btrfs filesystem using 6 partitionless disks in RAID1 that's failing to mount. I've tried the common recommended safe check options, but I haven't gotten the disk to mount at all, even with -o ro,recovery. If necessary, I can try to use the recovery to another filesystem, but I have around 18 TB of data on the filesystem that won't mount, so I'd like to avoid that if there's some other way of recovering it.
> > >
> > > Versions:
> > > btrfs-progs v4.19.1
> > > Linux localhost 4.20.6-arch1-1-ARCH #1 SMP PREEMPT Thu Jan 31 08:22:01 UTC 2019 x86_64 GNU/Linux
> > >
> > > Based on my understanding of how RAID1 works with Btrfs, I would expect a single disk failure to not prevent the volume from mounting entirely, but I'm only seeing one disk with errors according to dmesg output, maybe I'm misinterpreting it:
> > >
> > > [  534.519437] BTRFS warning (device sdd): 'recovery' is deprecated, use 'usebackuproot' instead
> > > [  534.519441] BTRFS info (device sdd): trying to use backup root at mount time
> > > [  534.519443] BTRFS info (device sdd): disk space caching is enabled
> > > [  534.519446] BTRFS info (device sdd): has skinny extents
> > > [  536.306194] BTRFS info (device sdd): bdev /dev/sdc errs: wr 23038942, rd 22208378, flush 1, corrupt 29486730, gen 2933
> > > [  556.126928] BTRFS critical (device sdd): corrupt leaf: root=2 block=25540634836992 slot=45, unexpected item end, have 13882 expect 13898
> >
> >    It's worth noting that 13898-13882 = 16, which is a power of
> > two. This means that you most likely have a single-bit error in your
> > metadata. That, plus the checksum not being warned about, would
> > strongly suggest that you have bad RAM. I would recommend that you
> > check your RAM first before trying anything else that would write to
> > your filesystem (including btrfs check --repair).
> 
> Good catch!
> 
> I think that can account for the corrupt and generation errors. I
> don't know that memory errors can account for the large number of read
> and write errors, however. So there may be more than one problem.
> 
> 
> -- 
> Chris Murphy
>
--f186eda459244226b190407c0970b6f5
Content-Disposition: attachment;filename="btrfs.tar.gz"
Content-Type: application/x-gzip; name="btrfs.tar.gz"
Content-Transfer-Encoding: BASE64

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
Sy655JJLLrnkkksuueSSS9n0/8RtCTQAuAEA

--f186eda459244226b190407c0970b6f5--
