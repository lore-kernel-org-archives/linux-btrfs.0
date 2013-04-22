Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab3DVWbR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 18:31:17 -0400
Date: Mon, 22 Apr 2013 15:31:14 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey
Message-ID: <20130422223114.GD25389@lenny.home.zabbo.net>
References: <1366665213-17894-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366665213-17894-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +static void drop_all_caches()
> +{
> +	int value = 3;
> +	int fd;
> +
> +	if ((fd = open("/proc/sys/vm/drop_caches", O_WRONLY)) < 0) {
> +		fprintf(stderr, "Error opening drop caches: %d\n", errno);
> +		return;
> +	}
> +
> +	write(fd, &value, sizeof(int));
> +	close(fd);
> +}

fwiw drop_caches takes an ascii string, not a native int:

  open("/proc/sys/vm/drop_caches", O_WRONLY) = 3
  write(3, "\3\0\0\0", 4)                 = -1 EINVAL (Invalid argument)

--- test.c.busted	2013-04-22 15:22:57.593575545 -0700
+++ test.c	2013-04-22 15:29:25.358072087 -0700
@@ -7,7 +7,7 @@
 
 static void drop_all_caches()
 {
-	int value = 3;
+	char value[] = "3\n";
 	int fd;
 
 	if ((fd = open("/proc/sys/vm/drop_caches", O_WRONLY)) < 0) {
@@ -15,7 +15,7 @@
                return;
 	}
 
-	write(fd, &value, sizeof(int));
+	write(fd, value, sizeof(value) - 1);
 	close(fd);
 }
 
  open("/proc/sys/vm/drop_caches", O_WRONLY) = 3
  write(3, "3\n", 2)                      = 2

and all this makes me think that the write() return should probably have
been checked :).

- z
