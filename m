From: Philip Worrall <philip.worrall@googlemail.com>
Subject: compression type per extent
Date: Wed, 9 Jun 2010 10:18:21 +0100
Message-ID: <AANLkTikkFpiSdaoqd7Ut48Bh8U-cAsrKFQiFgDjxGfTm@mail.gmail.com>
References: <AANLkTinSk7Rx-6EK-xNFvBVMA-NKOOY9gpftRfc_XUJ1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinSk7Rx-6EK-xNFvBVMA-NKOOY9gpftRfc_XUJ1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I am trying to add some hooks to support different compression types

In end_compressed_bio_read(struct bio *bio, int err) (compression.c)
does anyone know how can i read the compression_type flag set for the
current extent being read for decompression.

I was looking at using btrfs_get_file_extent_compression but I am
unsure if this is correct in this function.

At the moment btrfs_zlib_decompress_biovec is called but obviously
this is because only zlib is supported right now.


Philip
