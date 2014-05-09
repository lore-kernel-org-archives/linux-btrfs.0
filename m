Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18253 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaEIMAY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 08:00:24 -0400
Date: Fri, 9 May 2014 15:00:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sbehrens@giantdisaster.de
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: add optional integrity check code
Message-ID: <20140509120007.GE32027@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Stefan Behrens,

The patch 5db0276014b8: "Btrfs: add optional integrity check code"
from Nov 1, 2011, leads to the following static checker warning:

	fs/btrfs/check-integrity.c:1099 btrfsic_process_metablock()
	warn: missing error code here? 'btrfsic_stack_frame_alloc()' failed. 'sf->error' = '0'

fs/btrfs/check-integrity.c
  1092  
  1093                                          next_stack =
  1094                                              btrfsic_stack_frame_alloc();
  1095                                          if (NULL == next_stack) {
  1096                                                  btrfsic_release_block_ctx(
  1097                                                                  &sf->
  1098                                                                  next_block_ctx);

Should we set "sf->error" here?  I don't know the code well enough to
say the answer.

  1099                                                  goto one_stack_frame_backwards;
  1100                                          }
  1101  
  1102                                          next_stack->i = -1;

regards,
dan carpenter
