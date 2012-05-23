Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:37867 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab2EWJIP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 05:08:15 -0400
Date: Wed, 23 May 2012 11:07:48 +0200
From: David Sterba <dave@jikos.cz>
To: Henry Bakker <bakker@sedsystems.ca>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Could btrfs-restore be extended to also restore file dates?
Message-ID: <20120523090748.GM24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <4FBC082D.9020707@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FBC082D.9020707@sedsystems.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2012 at 03:42:05PM -0600, Henry Bakker wrote:
> Any possibility of getting btrfs-restore to also restore the files
> timestamp?

Quick look, yes it is possible and quite straightforward. The function
restore.c:copy_file has direct access to the found on-disk inode item
and can access the time fileds, then simply setting them for the file.
Maybe it could restore more, like uid, gid or mode.


david
