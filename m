Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876AbbLGPfj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 10:35:39 -0500
Date: Mon, 7 Dec 2015 16:33:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naota@elisp.net>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH 1/3] btrfs-progs: test: umount if confirmation failed
Message-ID: <20151207153339.GF4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1449207447-1203-1-git-send-email-naota@elisp.net>
 <1449207447-1203-2-git-send-email-naota@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449207447-1203-2-git-send-email-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 04, 2015 at 02:37:25PM +0900, Naohiro Aota wrote:
> When a check in check_inode() failed, the test should umount test target
> file system. This commit add clean up umount line in failure path.

The lack of cleanup after failed tests is intentional (exceptions
possible). The tests are supposed to do cleanup if they pass but if they
fail the test environment could be examined. In case of more complex
setups (loop devices, dm devices) it's some work to set it up again.

We could add an optional per-test script cleanup.sh that does the
cleanup on demand (and is also run from tests/clean-tests.sh).
