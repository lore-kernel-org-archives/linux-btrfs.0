From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs on low end and high end FLASH
Date: Wed, 02 May 2012 01:41:40 +0100
Message-ID: <jnpvs5$pvi$1@dough.gmane.org>
References: <jnpr08$shq$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jnpr08$shq$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/05/12 00:18, Martin wrote:
> How well suited is btrfs to low-end and high-end FLASH devices?
> 
> 
> Paraphrasing from a thread elsewhere:
> 
> FLASH can be categorised into two classes, which have extremely
> different characteristics:
> 
> (a) the low-end (USB, SDHC, CF, cheap ATA SSD);

A good FYI detailing low-end FLASH devices is given on:

Flash memory card design
https://wiki.linaro.org/WorkingGroups/Kernel/Projects/FlashCardSurvey

For those examples, it looks like write chunks of 32kBytes or more may
well be a good idea...


> and (b) the high-end (SAS, PCIe, NAS, expensive ATA SSD).
> 
> 
> My own experience is that the low end (a) can have erase blocks as large
> as 4MBytes or more and they are easily worn out to failure. I've no idea
> what their page sizes might be nor what boundaries their wear levelling
> (if any) operate on.
> 
> Their normal mode of operation is to use a "FAT32" filesystem and to be
> filled up linearly with large files. I guess the more scattered layout
> of extN is non-too sympathetic to their normal operation.
> 
> 
> The high-end (b) may well have 4kByte pages or smaller but they will
> typically operate with multiple page chunks that are much larger, where
> 16kBytes appear to be the optimum performance size for the devices I've
> seen so far.
> 
> 
> How well does btrfs fit in with the features for those two categories?

Regards,
Martin



