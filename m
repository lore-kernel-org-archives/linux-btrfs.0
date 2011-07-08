From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Fri, 8 Jul 2011 18:06:30 +0100
Message-ID: <20110708170630.GF4284@yahoo.fr>
References: <20110703190913.GA4474@yahoo.fr>
 <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
 <20110708154123.GA17886@yahoo.fr>
 <1310141349-sup-9515@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310141349-sup-9515@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-08 12:15:08 -0400, Chris Mason:
[...]
> You described this workload as rsync, is there anything else running?
[...]

Nope. Nothing else. And at least initially, that was onto an
empty drive so basic copy.

rsync --archive --xattrs --hard-links --numeric-ids --sparse --acls


Cheers,
Stephane
