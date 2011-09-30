From: David Sterba <dave@jikos.cz>
Subject: Re: [BUG, integration-test] fs/btrfs/inode.c:835
Date: Fri, 30 Sep 2011 12:52:00 +0200
Message-ID: <20110930105200.GI22205@twin.jikos.cz>
References: <20110929220513.GH22205@twin.jikos.cz> <4E85081A.9030900@jp.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@Oracle.COM>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E85081A.9030900@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 30, 2011 at 09:06:50AM +0900, Tsutomu Itoh wrote:
> The problem might be solved by the following patch.
> 
>  http://marc.info/?l=linux-btrfs&m=131556023601191&w=2

Thanks! It's the same BUG_ON line. I rerun the test yesterday for the
scond time and it triggered again. Now I'm testing integration with
Miao's fix and so far no crash after a few rounds.


david
