Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57658 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab3G2Ri2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 13:38:28 -0400
Message-ID: <51F6A891.7070608@sandeen.net>
Date: Mon, 29 Jul 2013 12:38:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Josef Bacik <jbacik@fusionio.com>, jeff.liu@oracle.com,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: generic/315: add one more sync and more output
References: <1375118463-29654-1-git-send-email-jbacik@fusionio.com> <51F6A6DA.3080102@redhat.com>
In-Reply-To: <51F6A6DA.3080102@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/29/13 12:31 PM, Eric Sandeen wrote:
> Honest question: does one more sync make this deterministic, or is it a best-effort, um, hack?

I'm not quite sure why even 1 sync is needed.  :(

I'm not sure what bug this is trying to test; if you need 2 syncs for global space stats to accurately reflect the fact that you chopped off the end of a block, maybe that's ... still a bug?

Or if it's just the big-hammer question of "does the truncated space *ever* get freed?" then maybe umount/remount/check would tell you that more definitively.

-Eric
