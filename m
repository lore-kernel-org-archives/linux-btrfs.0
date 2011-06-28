From: Norbert Preining <preining@logic.at>
Subject: Re: [BUG] btrfs is tearing down whole kernel when disk is
	disconnected
Date: Tue, 28 Jun 2011 13:42:16 +0900
Message-ID: <20110628044216.GH6792@gamma.logic.tuwien.ac.at>
References: <20110627014101.GA1517@gamma.logic.tuwien.ac.at> <1865303E0DED764181A9D882DEF65FB69F4CCC13B8@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB69F4CCC13B8@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Zhong,

On Mo, 27 Jun 2011, Zhong, Xin wrote:
> We met this situation in meego too:
> https://bugs.meego.com/show_bug.cgi?id=18156

Ah, good to hear that I am not the only one.
(Last time I was told: "It only happens to you!" until the real bug
was found ;-)

> I am now working on a patch to handle this kind of IO problem more
> gracefully (at least for sync/umount) by using the error handling
> API (btrfs_std_error). So far, I am still debugging my patch. Will
> send it to mailing list for review later. 

Please include me in the recipient list when sending the patch, I will
give it a try!

Thanks

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SNITTERFIELD (n.)
Office noticeboard on which snitters (q.v.), cards saying 'You don't
have to be mad to work here, but if you are it helps !!!' and slightly
smutty postcards from Ibiza get pinned up by snitterbies (q.v.)
			--- Douglas Adams, The Meaning of Liff
