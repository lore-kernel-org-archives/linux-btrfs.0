Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:51934 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751170AbdFETAn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Jun 2017 15:00:43 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] Btrfs: Improve btrfs_ioctl_search_key documentation
References: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <6a978495-bbae-97d1-fb21-6b6015898c11@inwind.it>
Date: Mon, 5 Jun 2017 21:00:40 +0200
MIME-Version: 1.0
In-Reply-To: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-05 17:27, Hans van Kranenburg wrote:
> +	 * When doing a tree search, we're actually taking a slice from a linear
> +	 * search space of 136-bit keys:
> +	 *
> +	 * Key of the first possible item to be returned:
> +	 *   (min_objectid << 72) + (min_type << 64) + min_offset
> +	 * Key of the last possible item to be returned:
> +	 *   (max_objectid << 72) + (max_type << 64) + max_offset
> +	 *


As non English people, I prefer a less verbose and more programmatic form, like:

+	 * When doing a tree search, we're actually taking a slice from a linear
+	 * search space of 136-bit keys:
+        *
+	 * A key is returned if 
+	 *   ((min_objectid << 72) + (min_type << 64) + min_offset  <=
+        *        (objectid << 72) + (type << 64) + offset))  &&
+	 *   ((max_objectid << 72) + (max_type << 64) + max_offset >= 
+        *        (objectid << 72) + (type << 64) + offset))
+        *




> +	 * [...] In other
> +	 * words, they are not used to filter the type or offset of intermediate
> +	 * keys encountered.

Even this is correct, I still find a bit complicate to fully understand the meaning.

I would prefer to replace "not used" with "not usable"... But as stated above I am not a native English people :-)

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
