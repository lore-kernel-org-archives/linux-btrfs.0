Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35640 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932657AbdIFPQf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 11:16:35 -0400
Date: Wed, 6 Sep 2017 17:15:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 3/7] Move Btrfs RCU string to common library
Message-ID: <20170906151506.GT31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1503470354.git.osandov@fb.com>
 <1270f0e6bfea72e136a42c058afce74f01deab62.1503470354.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1270f0e6bfea72e136a42c058afce74f01deab62.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 22, 2017 at 11:46:01PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The RCU-friendly string API used internally by Btrfs is generic enough
> for common use. This doesn't add any new functionality but instead just
> moves the code and documents the existing API.

Ok for the changes, but please drop anything that just reformats the
argument list and/or shifts the long strings out of 80 columns. I
personally hate the "arguments aligned under the opening (" style and
can somehow live with that in new code, but if it's part of a patch
that's pure noise as I have to read all the changed lines and figure out
if they really are different or not. Thanks.
