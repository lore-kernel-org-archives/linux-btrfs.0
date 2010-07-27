From: Diego Calleja <diegocg@gmail.com>
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
Date: Wed, 28 Jul 2010 01:10:45 +0200
Message-ID: <201007280110.46059.diegocg@gmail.com>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.ibm.com, crscott@us.ibm.com,
	linux-kernel@vger.kernel.org
To: bchociej@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mi=E9rcoles, 28 de Julio de 2010 00:00:18 bchociej@gmail.com escribi=
=F3:
> With Btrfs's COW approach, an external cache (where data is moved to
> SSD, rather than just cached there) makes a lot of sense. Though thes=
e

As I understand it, what your proyect intends to do is to move "hot"
data to a SSD which would be part of a Btrfs pool, and not do any
kind of SSD caching, as bcache (http://lwn.net/Articles/394672/) does?
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
