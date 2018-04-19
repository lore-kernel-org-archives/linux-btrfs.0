Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:39578 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752511AbeDSAGP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 20:06:15 -0400
Date: Thu, 19 Apr 2018 01:06:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: d_instantiate() and unlock_new_inode() order in btrfs_mkdir()
Message-ID: <20180419000612.GF30522@ZenIV.linux.org.uk>
References: <20180419000029.GA133757@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180419000029.GA133757@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 05:00:29PM -0700, Eric Biggers wrote:
> Hi Chris and other btrfs folks,
> 
> btrfs_mkdir() calls d_instantiate() before unlock_new_inode(), which is wrong
> because it exposes the inode to lookups before it's been fully initialized.

Huh?  It *is* fully initialized by that point; what else is left to do?
