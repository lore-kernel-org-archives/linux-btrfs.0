Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38272 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754326AbdEISJQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 14:09:16 -0400
Date: Tue, 9 May 2017 20:09:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Christian Brauner <christian.brauner@canonical.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, nazar@mokrynskyi.com,
        lakshmipathi.g@gmail.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: send: fail on first -ENODATA only
Message-ID: <20170509180902.GK5491@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170429215405.1123-2-christian.brauner@ubuntu.com>
 <20170501130941.hw7fuaovdnuvaxbc@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170501130941.hw7fuaovdnuvaxbc@mailbox.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 01, 2017 at 03:09:41PM +0200, Christian Brauner wrote:
> The original bug-reporter verified that my patch fixes the bug. See
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=195597

Thanks, patch applied. I'll add reference to the changelog. 
