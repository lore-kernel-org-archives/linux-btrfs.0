From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Fix break before assignment
Date: Thu, 3 May 2012 16:04:15 +0200
Message-ID: <20120503140414.GK6740@twin.jikos.cz>
References: <1336052689-30973-1-git-send-email-daniel@quora.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <yanzheng@21cn.com>, Josef Bacik <josef@redhat.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1336052689-30973-1-git-send-email-daniel@quora.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 03, 2012 at 09:44:49PM +0800, Daniel J Blueman wrote:
> Fix control flow to store count before breaking loop.

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg10483.html
but it's a dead code anyway.
