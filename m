Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab3JHQe1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 12:34:27 -0400
Date: Tue, 8 Oct 2013 18:34:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Shilong Wang <wangshilong1991@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 10/12] Btrfs-progs: add '--block-size' option to
 control print result
Message-ID: <20131008163422.GA12986@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1381130508-8458-11-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20131008153439.GE4322@twin.jikos.cz>
 <CAP9B-Qm=BkJH_GrNfYxRAuo94zMz9DXu7yQ2aN7H7_OABFF9TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAP9B-Qm=BkJH_GrNfYxRAuo94zMz9DXu7yQ2aN7H7_OABFF9TQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 09, 2013 at 12:27:23AM +0800, Shilong Wang wrote:
> Thanks for finding this, the problem comes to patch [v3 9/12].
> When updating max columns len of child_qgroup, i miswrite qgroup->member to
> qgroup->parent, i have updated this patch and send a v4, it can be
> appiled without conflicts with later.

Works for me, thanks, replaced.
