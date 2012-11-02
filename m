Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:17804 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2KBUmw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 16:42:52 -0400
Message-ID: <509430B6.7040901@giantdisaster.de>
Date: Fri, 02 Nov 2012 21:44:38 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>
CC: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH] Add btrfs-show-super
References: <1351865850-21688-1-git-send-email-kreijack@inwind.it> <1351865850-21688-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351865850-21688-2-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2012 15:17, Goffredo Baroncelli wrote:
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>   Makefile           |    5 +-
>   btrfs-show-super.c |  284 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 288 insertions(+), 1 deletion(-)
>   create mode 100644 btrfs-show-super.c
>

Good enhancement! Thank you! I like and recommend this enhanced version 
of the btrfs-show-super tool.

Goffredo, you are doing a very good and valuable job on improving the 
Btrfs tools. And you are one of the main contributors to btrfs-progs. 
Especially because of the huge amount of code that you are contributing, 
I would like to ask you to make your C source code formatting rules 
consistent with the rest of the Btrfs source code. In particular, I am 
talking about the way you use spaces. It is always the first thing that 
I notice, and quite often I just stop reading patches after noticing 
that the C source formatting is violating the rules. Just imagine that 
the Linux kernel would be written in hundreds of different C formatting 
styles. What a pain for the eyes this would be. Patches would contain 
99% formatting changes. Source code would be almost unreadable. 
Therefore strict rules have been established how to format C code 
(including how to use spaces in the C code). The same rules should be 
applied to the btrfs-progs code. Please, please, please reconsider the 
way you place spaces when you submit Btrfs patches! See below. Don't 
feel offended, just place the spaces correctly, please! Your work is 
good, just the way you place spaces is not good :)


[...]
> +	for ( i = optind ; i < argc ; i++ ) {
+	for (i = optind; i < argc ; i++) {

[...]
> +		if (all){
> +			int idx;
> +			for (idx = 0 ; idx < BTRFS_SUPER_MIRROR_MAX ; idx++) {
+		if (all) {
+			int idx;
+			for (idx = 0; idx < BTRFS_SUPER_MIRROR_MAX; idx++) {

[...]
> +	if (ret != BTRFS_SUPER_INFO_SIZE ) {
> +		int e = errno;
> +
> +		/* check if the disk if too short for further superblock */
> +		if( ret == 0 && e == 0 )
+	if (ret != BTRFS_SUPER_INFO_SIZE) {
+		int e = errno;
+
+		/* check if the disk if too short for further superblock */
+		if (ret == 0 && e == 0)

[...]
> +	for (i = 0, p = sb->csum ; i < btrfs_super_csum_size(sb) ; i++ )
+	for (i = 0, p = sb->csum; i < btrfs_super_csum_size(sb); i++)

[...]
> +	for (i = 0 ; i < 8 ; i++ )
+	for (i = 0; i < 8; i++)

[...]
> +	for (i = 0 ; i < BTRFS_LABEL_SIZE && s[i] ; i++)
+	for (i = 0; i < BTRFS_LABEL_SIZE && s[i]; i++)


The Linux kernel sources contain docs and tools for the formatting issue:
- Documentation/CodingStyle describes the C source code formatting rules 
that are expected in the Linux world.
- scripts/checkpatch.pl can detect lots of violations to these 
formatting rules.

