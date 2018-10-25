Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB9FC46475
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 09:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F091A2064C
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 09:47:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="O1qiTrHq";
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="O1qiTrHq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F091A2064C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=mail.ru
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbeJYSTU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 14:19:20 -0400
Received: from fallback12.mail.ru ([94.100.179.29]:55414 "EHLO
        fallback12.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbeJYSTU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 14:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Message-ID:References:In-Reply-To:Subject:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=nmiR8iXM/xuE0bJAtr9JxinlUc+P4vxk0C/YcABFieo=;
        b=O1qiTrHquQGqyOfXm7k3wjU6DRs6rGSPdGezYQLBQYdQ5rO7DXKwu9qyDSAt1P7rduJ66lvsdEekqQ6yEmliMCyA88Wi0vYT2NPOi4YFqP1XZy97DmG7wXLp2EuhLj+AtFscXNbhrTGVngvJ9mSMWnc9MvcoS3VqLd54yjbO6a4=;
Received: from [10.161.22.26] (port=40432 helo=smtp56.i.mail.ru)
        by fallback12.m.smailru.net with esmtp (envelope-from <dma_k@mail.ru>)
        id 1gFcEX-0000L3-Oa
        for linux-btrfs@vger.kernel.org; Thu, 25 Oct 2018 12:47:17 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Message-ID:References:In-Reply-To:Subject:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=nmiR8iXM/xuE0bJAtr9JxinlUc+P4vxk0C/YcABFieo=;
        b=O1qiTrHquQGqyOfXm7k3wjU6DRs6rGSPdGezYQLBQYdQ5rO7DXKwu9qyDSAt1P7rduJ66lvsdEekqQ6yEmliMCyA88Wi0vYT2NPOi4YFqP1XZy97DmG7wXLp2EuhLj+AtFscXNbhrTGVngvJ9mSMWnc9MvcoS3VqLd54yjbO6a4=;
Received: by smtp56.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
        id 1gFcEV-00009l-Kf
        for linux-btrfs@vger.kernel.org; Thu, 25 Oct 2018 12:47:16 +0300
Received: from www.centurion.link (localhost [IPv6:::1])
        by centurion.home (Postfix) with ESMTP id D7B8EF26091
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 11:47:13 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 25 Oct 2018 11:47:13 +0200
From:   Dmitry Katsubo <dma_k@mail.ru>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Failover for unattached USB device
In-Reply-To: <CAJCQCtQqus2ytiBCe=TZsWNsBNDy-SR064r1bPsyC5hL3iaJKQ@mail.gmail.com>
References: <dac5a4c5-e40d-a332-420f-f5517730a5f4@mail.ru>
 <3051750f58524cceed2a69fcf43bae31@mail.ru>
 <CAJCQCtQqus2ytiBCe=TZsWNsBNDy-SR064r1bPsyC5hL3iaJKQ@mail.gmail.com>
Message-ID: <e3d54b3d15a57d8fcd34e7a5bb9139c1@mail.ru>
X-Sender: dma_k@mail.ru
User-Agent: Roundcube Webmail/1.2.3
X-77F55803: aJWQtj4KSwERr4M/TTfF0v8rENpuJHA6b8r3odcYbpUfzcaETv0UOw==
X-7FA49CB5: 0D63561A33F958A57DA98982BA7DD810DC7899C981A7EA1F8CB66A59A9DD22F48941B15DA834481FA18204E546F3947CEDCF5861DED71B2F389733CBF5DBD5E9C8A9BA7A39EFB7666BA297DBC24807EA117882F44604297287769387670735209ECD01F8117BC8BEA471835C12D1D977C4224003CC8364767815B9869FA544D8090A508E0FED6299176DF2183F8FC7C0040F9FF01DFDA4A8E0C89D67371282C4A18204E546F3947CDA7BFA4571439BB2BA3038C0950A5D36581343779C53C132BD4B6F7A4D31EC0B7815B9869FA544D8EC76A7562686271E6BA297DBC24807EA089D37D7C0E48F6C8AA50765F790063714AEB5D162FBFCDD8CD3E666234B4F66089D37D7C0E48F6C5571747095F342E857739F23D657EF2B6825BDBE14D8E7028C9DFF55498CEFB0BD9CCCA9EDD067B1EDA766A37F9254B7
X-Mailru-Sender: 6DAAA20F2058E07D134D6D8D77B89E7FBB2C7102325FF13FD2C9FDD36A51C6B917110EB169E2A517501E7C294F69090ED50E20E2BC48EF5AE609D43F356B221EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: OK
X-77F55803: ZpkB5GJZEqkgE17o7U3wOu5P3qzN7PgHGobjR0uEnw4Gq4XA5tUC+A==
X-7FA49CB5: 0D63561A33F958A57ACA6B728ED9DA29BAFDA265502141F40A2C0F6C723AD1B48941B15DA834481FA18204E546F3947CEDCF5861DED71B2F389733CBF5DBD5E9C8A9BA7A39EFB7666BA297DBC24807EA117882F44604297287769387670735209ECD01F8117BC8BEA471835C12D1D977C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-Mailru-Sender: A5480F10D64C9005A1123343B979523432AE70A5742C7E9365D1B8C06914CD7ED711BC2D8DF26660D7448B40F9645FF708335C02508E532C672654BDC5BB03D95FEEDEB644C299C0ED14614B50AE0675
X-Mras: OK
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-10-24 20:05, Chris Murphy wrote:
> I think about the best we can expect in the short term is that Btrfs
> goes read-only before the file system becomes corrupted in a way it
> can't recover with a normal mount. And I'm not certain it is in this
> state of development right now for all cases. And I say the same thing
> for other file systems as well.
> 
> Running Btrfs on USB devices is fine, so long as they're well behaved.
> I have such a setup with USB 3.0 devices. Perhaps I got a bit lucky,
> because there are a lot of known bugs with USB controllers, USB bridge
> chipsets, and USB hubs.
> 
> Having user definable switches for when to go read-only is, I think
> misleading to the user, and very likely will mislead the file system.
> The file system needs to go read-only when it gets confused, period.
> It doesn't matter what the error rate is.

In general I agree. I just wonder why it couldn't happen quicker. For
example, from the log I've originally attached one can see that btrfs
made 1867 attempts to read (perhaps the same) block from both devices
in RAID1 volume, without success:

BTRFS error (device sdf): bdev /dev/sdh errs: wr 0, rd 1867, flush 0, 
corrupt 0, gen 0
BTRFS error (device sdf): bdev /dev/sdg errs: wr 0, rd 1867, flush 0, 
corrupt 0, gen 0

Attempts lasted for 29 minutes.

> The work around is really to do the hard work making the devices
> stable. Not asking Btrfs to paper over known unstable hardware.
> 
> In my case, I started out with rare disconnects and resets with
> directly attached drives. This was a couple years ago. It was a Btrfs
> raid1 setup, and the drives would not go missing at the same time, but
> both would just drop off from time to time. Btrfs would complain of
> dropped writes, I vaguely remember it going read only. But normal
> mounts worked, sometimes with scary errors but always finding a good
> copy on the other drive, and doing passive fixups. Scrub would always
> fix up the rest. I'm still using those same file systems on those
> devices, but now they go through a dyconn USB 3.0 hub with a decently
> good power supply. I originally thought the drop offs were power
> related, so I explicitly looked for a USB hub that could supply at
> least 2A, and this one is 12VDC @ 2500mA. A laptop drive will draw
> nearly 1A on spin up, but at that point P=AV. Laptop drives during
> read/write using 1.5 W to 2.5 W @ 5VDC.
> 
> 1.5-2.5 W = A * 5 V
> Therefore A = 0.3-0.5A
> 
> And for 4 drives at possibly 0.5 A (although my drives are all at the
> 1.6 W read/write), that's 2 A @ 5 V, which is easily maintained for
> the hub power supply (which by my calculation could do 6 A @ 5 V, not
> accounting for any resistance).
> 
> Anyway, as it turns out I don't think it was power related, as the
> Intel NUC in question probably had just enough amps per port. And what
> it really was, was incompatibility between the Intel controller and
> the bridgechipset in the USB-SATA cases, and the USB hub is similar to
> an ethernet hub, it actually reads the USB stream and rewrites it out.
> So hubs are actually pretty complicated little things, and having a
> good one matters.

Thanks for this information. I have a situation similar to yours, with
only important difference that my drives are put into the USB dock with
independent power and cooling like this one:

https://www.ebay.com/itm/Mediasonic-ProBox-4-Bay-3-5-Hard-Drive-Enclosure-USB-3-0-eSATA-Sata-3-6-0Gbps/273161164246

so I don't think I need to worry about amps. This dock is connected
directly to USB port on the motherboard.

However indeed there could be bugs both on dock side and in south 
bridge.
More over I could imagine that USB reset happens due to another USB 
device,
like a wave stated in one place turning into tsunami for the whole
USB subsystem.

> There are pending patches for something similar that you can find in
> the archives. I think the reason they haven't been merged yet is there
> haven't been enough comments and feedback (?). I think Anand Jain is
> the author of those patches so you might dig around in the archives.
> In a way you have an ideal setup for testing them out. Just make sure
> you have backups...

Thanks for reference. Should I look for this patch here:

https://patchwork.kernel.org/project/linux-btrfs/list/?submitter=34632&order=-date

or this patch was only floating around in this maillist?

> 'btrfs check' without the --repair flag is safe and read only but
> takes a long time because it'll read all metadata. The fastest safe
> way is to mount it ro and read a directory recently being written to
> and see if there are any kernel errors. You could recursively copy
> files from a directory to /dev/null and then check kernel messages for
> any errors. So long as metadata is DUP, there is a good chance a bad
> copy of metadata can be automatically fixed up with a good copy. If
> there's only single copy of metadata, or both copies get corrupt, then
> it's difficult. Usually recovery of data is possible, but depending on
> what's damaged, repair might not be possible.

I think "btrfs check" would be too heavy. Monitoring kernel errors is
something I was thinking about as well.

I didn't observe any errors while doing "btrfs check" on this volume 
after
several such resets, because that volume is mostly used for reading and
chance that USB reset happens during the write is very low.

-- 
With best regards,
Dmitry
