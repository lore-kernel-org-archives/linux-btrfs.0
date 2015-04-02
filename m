Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbbDBQVE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 12:21:04 -0400
Date: Thu, 2 Apr 2015 18:21:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND] fstests: test for btrfs send after complex
 directory hierarchy changes
Message-ID: <20150402162101.GO6821@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427971726-13160-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427971726-13160-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 02, 2015 at 11:48:46AM +0100, Filipe Manana wrote:
> Test a very complex scenario for a btrfs incremental send operation where a
> large directory hierarchy had many subtrees moved between parent directories,
> preserving the names of some directories and inverting the parent-child
> relationship between some directories (a child in the parent snapshot became
> a parent, in the send snapshot, of the directory that is its parent in the
> parent snapshot).
> 
> This test made the incremental send fail with -ENOMEM because it entered an
> infinite loop when building path strings that are used as operands of the
> rename operations issued in the send stream.
> This issue was fixed by the following linux kernel btrfs patch:
> 
>    Btrfs: incremental send, don't delay directory renames unnecessarily
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

Tested with current master (4.0-rc6) where it fails. The out of memory
failure is fixed by the mentioned kernel patch, though to fully pass the
test it's needed to also include

"Btrfs: incremental send, clear name from cache after orphanization"
https://patchwork.kernel.org/patch/5996271/
