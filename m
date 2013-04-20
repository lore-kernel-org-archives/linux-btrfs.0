Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52547 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab3DTXNc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 19:13:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UTgyD-0006y0-IH
	for linux-btrfs@vger.kernel.org; Sun, 21 Apr 2013 01:13:25 +0200
Received: from mail.kingswood-consulting.co.uk ([88.97.16.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 01:13:25 +0200
Received: from frank by mail.kingswood-consulting.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 01:13:25 +0200
To: linux-btrfs@vger.kernel.org
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
Subject: Re: [PATCH] btrfs-progs: update mkfs.btrfs help info for raid5/6
Date: Sun, 21 Apr 2013 00:13:06 +0100
Message-ID: <51732102.6080104@kingswood-consulting.co.uk>
References: <1362361048-30744-1-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <1362361048-30744-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/03/13 01:37, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>
>    Since raid5/6 support was introduced, we should update mkfs.btrfs help info.
>
> Signed-off-by: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
> ---
>   mkfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mkfs.c b/mkfs.c
> index 5ece186..f9f26a5 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -326,7 +326,7 @@ static void print_usage(void)
>   	fprintf(stderr, "options:\n");
>   	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
>   	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
> -	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10, dup or single\n");
> +	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
>   	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
>   	fprintf(stderr, "\t -L --label set a label\n");
>   	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");

Nitpick: that line of output is now longer than 80. Perhaps instead of 
"\t " have a few spaces at the start of each line.

Frank

