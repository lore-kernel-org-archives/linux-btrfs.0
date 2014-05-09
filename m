Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:46814 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEINJM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 09:09:12 -0400
Message-ID: <536CD1FA.2000200@giantdisaster.de>
Date: Fri, 09 May 2014 15:02:50 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs: add optional integrity check code
References: <20140509120007.GE32027@mwanda>
In-Reply-To: <20140509120007.GE32027@mwanda>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 9 May 2014 15:00:07 +0300, Dan Carpenter wrote:
> Hello Stefan Behrens,
> 
> The patch 5db0276014b8: "Btrfs: add optional integrity check code"
> from Nov 1, 2011, leads to the following static checker warning:
> 
> 	fs/btrfs/check-integrity.c:1099 btrfsic_process_metablock()
> 	warn: missing error code here? 'btrfsic_stack_frame_alloc()' failed. 'sf->error' = '0'
> 
> fs/btrfs/check-integrity.c
>   1092  
>   1093                                          next_stack =
>   1094                                              btrfsic_stack_frame_alloc();
>   1095                                          if (NULL == next_stack) {
>   1096                                                  btrfsic_release_block_ctx(
>   1097                                                                  &sf->
>   1098                                                                  next_block_ctx);
> 
> Should we set "sf->error" here?  I don't know the code well enough to
> say the answer.
> 
>   1099                                                  goto one_stack_frame_backwards;
>   1100                                          }
>   1101  
>   1102                                          next_stack->i = -1;

Looking at this function immediately made me blind and getting terrible
headache, therefore I can only guess whether not setting sf->error was
intentional or not three years ago. Nowadays, I'd set sf->error since
this propagates the error condition upwards. Although it doesn't make a
difference to the user and doesn't cause a crash whether it is set or
not. But if the function returns an error/success status, and an error
was detected, the error status should be returned. I'll send a patch.

