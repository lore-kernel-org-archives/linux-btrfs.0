Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9011 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbaJEVPZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Oct 2014 17:15:25 -0400
From: Josef Bacik <jbacik@fb.com>
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Empty directory can't be removed, "not empty"
Date: Sun, 5 Oct 2014 21:15:20 +0000
Message-ID: <4y4ujgfg4nl0f6o31tmhuuvv.1412543718947@email.android.com>
References: <20141005191254.46cb7e7f@natsu>
In-Reply-To: <20141005191254.46cb7e7f@natsu>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fsck will fix it, its a bug from way back when.  Thanks,

Josef

Roman Mamedov <rm@romanrm.net> wrote:


Hello,

After an improper shutdown (power loss), I got one of these again:

# ls -la junk/
total 0
drwx------ 1 rm   rm   4152 Oct  5 18:44 .
drwxr-xr-x 1 root root   72 Oct  5 19:10 ..

# rm -rvf junk/
rm: cannot remove `junk': Directory not empty

The kernel version is 3.4.18.
If this helps, initially it was a Chromium browser profile directory; and it
had nodatacow files in it (chattr +C).
How to actually remove this directory now?

--
With respect,
Roman
