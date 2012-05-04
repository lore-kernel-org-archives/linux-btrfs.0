From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: BTRFS RAID
Date: Fri, 4 May 2012 18:14:37 +0200
Message-ID: <20120504161437.GB5490@mother.jarsat.pl>
References: <D3E77A47-E10E-49F2-B07C-7D2CDBB22C06@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <D3E77A47-E10E-49F2-B07C-7D2CDBB22C06@me.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 04, 2012 at 09:46:15AM -0500, Michael Bailey wrote:
> Greetings,
> 
> I have a few questions pertaining to BTRFS RAID.  I know it's been rumored a lot recently that kernel 3.4 will have RAID5/6 support, is this still the case.

  It seem to be wrong. Chris Mason hinted that RAID5/6 will hit kernel 3.5.  It is way to late to have it in 3.4.


>  Also, is it possible to change from a single drive system to a raid system or even a multi drive system without raid to a raid system while there is data on the drives an successfully convert them without loosing data?  Thank you for any help you can provide.

  Restriping had landed, so it should be doable.

-- 
Tomasz Torcz                 "God, root, what's the difference?"
xmpp: zdzichubg@chrome.pl         "God is more forgiving."

