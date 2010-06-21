From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: How to un degrade RAID10.
Date: Mon, 21 Jun 2010 08:16:21 +0200
Message-ID: <20100621061620.GA32230@mother.pipebreaker.pl>
References: <1277098982.4c1efbe612349@postoffice.tpg.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1277098982.4c1efbe612349@postoffice.tpg.com.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 21, 2010 at 03:43:02PM +1000, ibm-main@tpg.com.au wrote:
> Did a (normal, non-RAID) mkfs on the partition, then attempted to add it
> back as per the wiki. Won't mount without the degraded option even
> though the 4 partitions are accepted o.k, and a re-balance worked.
> The array now reports as 5 devices with #2 (the original slot for sda8)
> now vacant - dare I say "missing". It reports as "*** Some devices missng"
> This seems counter intuitive to me. Suggestions ?.

  You can pass "missing" to "btrfs device delete".

-- 
Tomasz Torcz              ,,If you try to upissue this patchset I shall be seeking
xmpp: zdzichubg@chrome.pl   an IP-routable hand grenade.'' -- Andrew Morton (LKML)

