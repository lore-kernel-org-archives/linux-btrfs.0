From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Date: Mon, 19 Sep 2011 19:52:03 +0200
Message-ID: <20110919175203.GK7761@one.firstfloor.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <1316128013-21980-2-git-send-email-andi@firstfloor.org> <20110916154815.GA27150@infradead.org> <4E7439EB.7080100@oracle.com> <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca> <20110918014608.GA16198@alboin.amr.corp.intel.com> <4E759DE5.3020907@oracle.com> <4E75AEFD.105@gmail.com> <8444301C-856F-44FA-94A3-D3583DFA0FFB@oracle.com> <1316357705-sup-2667@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff liu <jeff.liu@oracle.com>,
	Marco Stornelli <marco.stornelli@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1316357705-sup-2667@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

> Thanks everyone, I've put Jeff's last version of this in my queue.

Can you post the version you merged? The previous ones all had issues.

-Andi
