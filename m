From: Daniel J Blueman <daniel@quora.org>
Subject: Re: [PATCH] Fix break before assignment
Date: Thu, 3 May 2012 22:39:02 +0800
Message-ID: <CAMVG2sv+1Eroo7s-si+h1gj1ft=MGpzt5ofHq2j+qBMO6Lw23Q@mail.gmail.com>
References: <1336052689-30973-1-git-send-email-daniel@quora.org>
	<20120503140414.GK6740@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dave@jikos.cz, Yan Zheng <yanzheng@21cn.com>,
	Josef Bacik <josef@redhat.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120503140414.GK6740@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 3 May 2012 22:04, David Sterba <dave@jikos.cz> wrote:
> On Thu, May 03, 2012 at 09:44:49PM +0800, Daniel J Blueman wrote:
>> Fix control flow to store count before breaking loop.
>
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg10483.html
> but it's a dead code anyway.

Noted.

Chris, is it a good time to take out btrfs_insert_some_items or, if
keeping it, apply David's patch to avoid related surprises?

Thanks,
  Daniel
-- 
Daniel J Blueman
