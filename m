Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab3ANSQo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 13:16:44 -0500
Date: Mon, 14 Jan 2013 10:16:43 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        ablock84@googlemail.com
Subject: Re: [PATCH 2/3] btrfs-progs: libify some parts of btrfs-progs
Message-ID: <20130114181643.GR12558@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1357681304-2978-1-git-send-email-mfasheh@suse.de> <1357681304-2978-3-git-send-email-mfasheh@suse.de> <50EFDBDD.1040104@oracle.com> <20130111230058.GN12558@wotan.suse.de> <50F37E8D.3070107@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F37E8D.3070107@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 14, 2013 at 11:42:05AM +0800, Anand Jain wrote:
>
>
> Mark,
>
>  Its bit strange, the steps given before can reproduce
>  the problem still on my older workspace. However when
>  I try with the fresh clone, it can reproduce the issue
>  (4 times, consistently) only with the following (new)
>  steps..

Ok.


> # git clone 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>
> # cd btrfs-progs/
> # make version; make install

Ahh, this *does* reproduce for me. I think we just need to add libbtrfs as a
target somewhere. I'll fix it up. Thanks so much for drilling down to a test
case!
	--Mark

--
Mark Fasheh
