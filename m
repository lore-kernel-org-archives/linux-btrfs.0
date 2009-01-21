From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: check return value for kthread_run() correctly
Date: Wed, 21 Jan 2009 09:56:07 -0500
Message-ID: <1232549767.17244.4.camel@think.oraclecorp.com>
References: <4974aa4d.0e0d6e0a.4824.5c2b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4974aa4d.0e0d6e0a.4824.5c2b@mx.google.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-20 at 00:28 +0800, Qinghuang Feng wrote:
> kthread_run() returns the kthread or ERR_PTR(-ENOMEM), not NULL.
> 

Thanks, got it.

-chris


