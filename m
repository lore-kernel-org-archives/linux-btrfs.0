From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH] xfstests: new check 276 to ensure btrfs backref integrity
Date: Thu, 22 Dec 2011 11:59:31 +0100
Message-ID: <4EF30D93.1090805@jan-o-sch.net>
References: <1323264833-11075-1-git-send-email-list.btrfs@jan-o-sch.net> <4EF21BE0.4020009@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EF21BE0.4020009@sandeen.net>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the feedback. I've now removed the $fresh code completely as
it's not meant to be used by anyone but me :-)

_require_btrfs will become a new helper in common.rc. Will resend soon
as 278 (hoping that number holds).

-Jan
