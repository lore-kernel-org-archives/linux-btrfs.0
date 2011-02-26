From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
Date: Sat, 26 Feb 2011 15:59:27 +0100
Message-ID: <4D69154F.8090000@gmail.com>
References: <4D6221B8.9040303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, xfs@oss.sgi.com,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <4D6221B8.9040303@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Il 21/02/2011 09:26, Marco Stornelli ha scritto:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> All fs must check for the immutable flag in their fallocate callback.
> It's possible to have a race condition in this scenario: an application
> open a file in read/write and it does something, meanwhile root set the
> immutable flag on the file, the application at that point can call
> fallocate with success. Only Ocfs2 check for the immutable flag at the
> moment.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

no comments?
