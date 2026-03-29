Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044B731E83D
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 17:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774805027; cv=none; b=ov8Jc1vDqJVnPdqGFab3fbZSAcrf0Z3+wnnUELJznQ9z7Xe/quv5jDfZTX7EszRL/QzbcF9GD+td+n7NTpYbNqWQX8Ex5eJgUbhQ/XaNgR54Mhw8X7ytYhplz/VGRkOB1pPPPSyMZd3XVauNznd9bpvRWMVuoSfw1GbycWoIeB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774805027; c=relaxed/simple;
	bh=hcAE3yeCmb/ooluKUxqFOymuECNrqaZcMKJlGlrZuys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LIXXF3QQLTc3p9SpGyhbvYAXTN5VJVoCnEJRCo/mh19NHouzEyMNN0mtAzkAeGQDhAnGBpZNi2v0Alnu1ARtMm9if+qAEUryOQxNA1zGfWzpUyWg06zK6oVa0ozlbmORUBgy5yy5MH0goBTB2ODDrbN9aRL6lkSHpBAtqL5xZ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GclSeAQA; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GclSeAQA"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48540d21f7dso43676335e9.0
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 10:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774805024; x=1775409824; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HEqLYX6RlhLf8loZnBNWRjt8pvMWIJoaUUPEjz3I7gQ=;
        b=GclSeAQAPKV4Cy90QkTZ5oWcMCU9ozBdfmJdqD2qp7awbupiDRVXHTpg6ZzFxpmQrV
         ZmSXfHgXRrHCMhCdikeF0dwzEGto6o4yh+L/UNHeF3Wa1hvdPi+1tD08krvmpRqhFjPf
         7c4FMYoo0FQDR2ujlssi8/jQrOYK64GUU4iddEVuPfVZ+764jjjKLXsByMdmA7y+avLe
         c1xRo8t5L2GMAjlYxsX4I1I2JkeO0ynkVgjIfv5zPRLrvOskblyMeGIMZzm0rrszgYL1
         aB/6eQPBeF1gSFrVlM4oV3qAwU86Bga3cAcxcRIhYhB1gHDp4SOWp0b3R4CrGjwDhmjq
         O2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774805024; x=1775409824;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HEqLYX6RlhLf8loZnBNWRjt8pvMWIJoaUUPEjz3I7gQ=;
        b=H7jq6GnQpNThJmL5SknOixodihQOITER/Y5/1gCDP4HzD7NotxIJe5Fg22W8PqPtO7
         Luc6wdsGyydGpCSt4N2QGIQG9/d+gUhaR3tFux+hRrFZAQSrI6Xhy7SJPEFMa5MLROnT
         Dr19kSeHTw0ESwlDR30VqRIz/Wj8FQU+yJKIQITaKVeO5mCO0ao6cuPe0CZlYZcRwSfG
         iN5K2aOa/UvgVHOB4wfKqyLa4MMhe1nYc60rZt7fgDYdQWZCES119iVYo8QW5SyUSmXg
         sI9z2dLz8l/YuEO6Cu2/2+Mc6e59sVNhwtlp3OIxA5NWSigvqjhnGnVHrRK4z/R5hFT3
         B5Tg==
X-Forwarded-Encrypted: i=1; AJvYcCVZt/Vws3yYGBedJ2reejnii3JHcZaQ2tcuB8V6An0ZnJsitvxwx7XDWAPcJkhZS016RQJEdluGJP20kg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvN5db+ie+sogjgNNIDxILjcfu4q8tptsbJW9e7VRkvIhfWN34
	g/ArclDgUk/zMeoQPQAsY1tm+M6CvAh9VvcfrYhlfVpOOnCCxlqFu7iQ
X-Gm-Gg: ATEYQzyi3gpenOYAEbZug26W2n1/VWuGpQj2xHUYL0rpujA9KyNOXkR95FR17igCAl7
	7PhkGfcQwqe8DhsT2htTq+t6VhsE5mRJZ0q/pbu+/K3cLYDnIYcueLSb7VfhKzdxLut31H/ooXn
	0nXE+Vb/XcUBBWC5WCWqyWQ8SVBLykws0kOBX2es5xtn/kt2K+B5VV0a2VXmX0qdk98tDVNc5Dt
	wkiH13VEPzk+Kumr7NHOCXVJnu6c4hNf+Myms0exkdmdtXkO0KGwoLt2fMN9zMHqIH7tb4sjiwn
	s1c80aw10TUaYKgaRTTAOnLgCBH3aWc7MF8fZyeIp5NnlKbMDOn0PkuXdd5GEB2jI7hf4kFri0q
	wwPCAq6vI1sOSaRMSioGwHyPxZBQF4vyOoXwHAeBXXxB3sXETzkWScHOTZ7f+hqZCIg/JjBSQL4
	WctEM/V/nXiqWcCu4B/MLcw5Q=
X-Received: by 2002:a05:600c:5304:b0:485:f1d1:8f3d with SMTP id 5b1f17b1804b1-48727d67a43mr164954725e9.6.1774805024020;
        Sun, 29 Mar 2026 10:23:44 -0700 (PDT)
Received: from rabbitArch ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722c6b495sm434962275e9.2.2026.03.29.10.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 10:23:43 -0700 (PDT)
Date: Sun, 29 Mar 2026 19:23:41 +0200
From: Teng Liu <27rabbitlt@gmail.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: wait for in-flight readahead BIOs on open_ctree()
 error
Message-ID: <aclYf4R2XxlUkxAQ@rabbitArch>
References: <20260329063417.642647-1-27rabbitlt@gmail.com>
 <11c944aa-7745-4720-9f40-af99bf7bb727@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11c944aa-7745-4720-9f40-af99bf7bb727@suse.com>

Thanks for your review!
On 2026-03-29 17:33, Qu Wenruo wrote:
> 
> 
> This doesn't make any sense to me.
It confuses me as well when I try to reproduce the bug. The reported
claimed that btrfs_bio_counter_sub triggered a use-after-free but this
function lives under `dev-reaplce.c` which should have nothing to do
with the setting from the name.

However when I checked the function call chain: 

open_ctree()
  → btrfs_read_sys_array()          # OK — sys_chunk_array in superblock is intact
  → load_super_root(chunk_root)     # OK — reads root node, passes validation
  → btrfs_read_chunk_tree()
      → btrfs_for_each_slot()
          → readahead_tree_node_children(node)
              → for each child pointer in the internal node:
                  btrfs_readahead_node_child()
                    → btrfs_readahead_tree_block()
                      → read_extent_buffer_pages_nowait()
                        → btrfs_submit_bbio()
                          → btrfs_submit_chunk()
                            → btrfs_bio_counter_inc_blocked()  ← bio_counter++
                            → btrfs_map_block()               
                            → submit_bio()                     ← sent to USB drive

After submit_bio() sends BIO to USB drive, we continue on
read_one_dev():

open_ctree()
  → btrfs_read_sys_array()          # OK — sys_chunk_array in superblock is intact
  → load_super_root(chunk_root)     # OK — reads root node, passes validation
  → btrfs_read_chunk_tree()
      → btrfs_for_each_slot()
          → readahead_tree_node_children(node)
            → bio_coutner++ and submit_bio() send BIO to USB drive
          → read_one_dev()

This read_one_dev will return an error since the leaf block is actually
corrupted. Then open_ctree will get into error path and try to free
fs_info. 

After USB device finished BIO, it will try to decreament the counter but
the fs_info is already freed.

Any suggestions on this?


> 
> The wait and counter are all for dev-reaplce, not matching your description
> of the generic metadata readahead.
> 
> If you want to wait for all existing metadata reads, I didn't find a good
> helper, thus you will need to go through all extent buffers and wait for
> EXTENT_BUFFER_READING flags.
> 
> 


