From: jim owens <owens6336@gmail.com>
Subject: Re: [PATCH V2] Btrfs: Full direct I/O and AIO read implementation.
Date: Wed, 03 Mar 2010 13:54:34 -0500
Message-ID: <4B8EB06A.1030401@gmail.com>
References: <4B7300BE.5000909@hp.com> <20100212192804.GE4191@localhost.localdomain> <4B7AF1C0.6030904@gmail.com> <20100216193958.GD17106@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100216193958.GD17106@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

The following 6 patches [dio.c V2 #/6] are code cleanup
from your review and my testing on a 32 bit laptop.

These patches do not have any changes to remove the
hard coded 511/512 or i_mutex.  That will come later.

These patches are only to make it easier to see what
I have done, I will roll them up into a V3 dio.c.

jim
