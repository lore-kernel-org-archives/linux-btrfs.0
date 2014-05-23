Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbaEWJgG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 05:36:06 -0400
Date: Fri, 23 May 2014 11:44:00 +0200
From: David Disseldorp <ddiss@suse.de>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfstests: add test for btrfs ioctl clone operation
Message-ID: <20140523114400.516d559e@f163.suse.de>
In-Reply-To: <1400817931-32326-2-git-send-email-fdmanana@gmail.com>
References: <1400817931-32326-1-git-send-email-fdmanana@gmail.com>
	<1400817931-32326-2-git-send-email-fdmanana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 23 May 2014 05:05:31 +0100, Filipe David Borba Manana wrote:

> This is a test to verify that the btrfs ioctl clone operation is
> able to clone extents of a file to different positions of the file,
> that is, the source and target files are the same. Existing tests
> only cover the case where the source and target files are different.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Nice work Filipe.

Reviewed-by: David Disseldorp <ddiss@suse.de>

Cheers, David
