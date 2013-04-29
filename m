Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298Ab3D2Ob4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 10:31:56 -0400
Date: Mon, 29 Apr 2013 16:31:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] Btrfs: support printing UUID tree elements
Message-ID: <20130429143153.GP16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
 <85b4a097a36353848383d0ac0339cb644a1cf2bb.1366384796.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <85b4a097a36353848383d0ac0339cb644a1cf2bb.1366384796.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 19, 2013 at 05:41:03PM +0200, Stefan Behrens wrote:
> --- a/fs/btrfs/print-tree.c
> +++ b/fs/btrfs/print-tree.c
> +static void print_uuid_item(struct extent_buffer *l,
> +			    struct btrfs_uuid_item *ptr,
> +			    u64 item_size)
> +{
> +	do {
> +		u64 sub_item_type;
> +		u64 sub_item_len;
> +		u64 subvol_id;
> +
> +		if (item_size < sizeof(*ptr)) {
> +			printk(KERN_INFO "btrfs: uuid item too short!\n");

please print the expected and found sizes (also in (2) below)

> +			return;
> +		}
> +		sub_item_type = btrfs_uuid_type(l, ptr);
> +		sub_item_len = btrfs_uuid_len(l, ptr);
> +		ptr++;
> +		item_size -= sizeof(*ptr);
> +		if (sub_item_len * 8 > item_size) {

For documentation purposes, I think using sizeof(u64) instead of 8.

> +			printk(KERN_INFO "btrfs: uuid item too short (2)!\n");
> +			return;
> +		}
> +
> +		item_size -= sub_item_len * 8;
> +		switch (sub_item_type) {
> +		case BTRFS_UUID_ITEM_TYPE_SUBVOL:
> +			while (sub_item_len) {
> +				read_extent_buffer(l, &subvol_id,
> +						   (unsigned long)ptr, 8);
> +				printk(KERN_INFO "\t\tsubvol_id %llu\n",
> +				       (unsigned long long)
> +					le64_to_cpu(subvol_id));
> +				sub_item_len--;
> +				ptr = (struct btrfs_uuid_item *)
> +					(((char *)ptr) + 8);

and this could be wrapped in a macro or function, it's repeated several
times in that function.

> +			}
> +			break;
> +		case BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL:
> +			while (sub_item_len) {
> +				read_extent_buffer(l, &subvol_id,
> +						   (unsigned long)ptr, 8);
> +				printk(KERN_INFO "\t\treceived_subvol_id %llu\n",
> +				       (unsigned long long)
> +					le64_to_cpu(subvol_id));
> +				sub_item_len--;
> +				ptr = (struct btrfs_uuid_item *)
> +					(((char *)ptr) + 8);
> +			}
> +			break;
> +		default:
> +			printk(KERN_INFO "\t\tunknown type=%llu, len=8*%llu\n",
> +			       (unsigned long long)sub_item_type,
> +			       (unsigned long long)sub_item_len);
> +			while (sub_item_len) {
> +				read_extent_buffer(l, &subvol_id,
> +						   (unsigned long)ptr, 8);
> +				printk(KERN_INFO "\t\tid %llu\n",
> +				       (unsigned long long)
> +					le64_to_cpu(subvol_id));
> +				sub_item_len--;
> +				ptr = (struct btrfs_uuid_item *)
> +					(((char *)ptr) + 8);
> +			}
> +			break;
> +		}
> +	} while (item_size);
> +}
