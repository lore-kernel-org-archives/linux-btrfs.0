From: "Joshua J. Berry" <des@condordes.net>
Subject: Re: compare COW files
Date: Mon, 20 Oct 2008 22:40:20 -0700
Message-ID: <200810202240.21679.des@condordes.net>
References: <20081021032552.2250.qmail@splitreflection.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: calin@splitreflection.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081021032552.2250.qmail@splitreflection.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 20 October 2008 20:25:52 calin wrote:
> If I make a cow copy of a file, is there a way find out whether either copy
> has changed?  Specifically, I'm looking for a way to figure out which files
> have changed since a snapshot was taken, short of traditional and
> time-consuming file comparisons.  It could have some interesting
> possibilities for monitoring and backup, to be able to quickly compare
> against a reference snapshot to find changes. --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'm also very interested in this, for incremental backups.  I use rdiff-backup 
currently, and being able to do this would likely give an impressive speed 
boost.

-- Josh


-- 
Joshua J. Berry

"I haven't lost my mind -- it's backed up on tape somewhere."
    -- /usr/games/fortune

