From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: [PATCH] btrfs: fixup module.h usage as required
Date: Thu, 15 Mar 2012 16:01:41 +0100
Message-ID: <20120315150141.GD6474@pambianco.com>
References: <1330305418-3507-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1330305418-3507-1-git-send-email-paul.gortmaker@windriver.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 26, 2012 at 08:16:58PM -0500, Paul Gortmaker wrote:
> Delete the instances of module.h that aren't actually used
> or needed.  Replace with export.h as required.

I'm using this patch without problem since you published it (compressed
/home with hourly snapshot delete/creation).

Thanks a lot for your work,
Andrea
