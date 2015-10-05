Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:35883 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751377AbbJEPm4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Oct 2015 11:42:56 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 4/4] btrfs-progs: change -t option for subvolume list to
 print a simple space-separated table (making it machine-readable)
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
 <1443804083-876-5-git-send-email-axel@tty0.ch> <560FA665.6000700@libero.it>
 <560FA944.3050606@digint.ch> <5610134D.9070807@inwind.it>
 <pan$c5775$3f0b408b$41f20753$9ede78d@cox.net> <561138F4.5090105@inwind.it>
 <56129171.4040200@digint.ch>
To: Axel Burri <axel@digint.ch>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56129A7C.8060701@inwind.it>
Date: Mon, 5 Oct 2015 17:42:52 +0200
MIME-Version: 1.0
In-Reply-To: <56129171.4040200@digint.ch>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Axel,

On 2015-10-05 17:04, Axel Burri wrote:
[...]
> 
> A quick look at the code shows me that Goffredo is right here, as
> __list_subvol_search() always fetches ALL data from
> BTRFS_IOC_TREE_SEARCH, putting it into a rbtree for later processing
> (assemble full paths, sorting).
> 
> While there is certainly room for improvements here (assuming that
> BTRFS_IOC_TREE_SEARCH returns objectid's in sorted order, it would
> definitively be possible to produce line-by-line output), the code looks
> pretty elegant the way it is.
> 
> I still don't think it is wise to bloat things further just for printing
> nice tables. My impression is that "btrfs subvolume list" is
> human-readable enough without the '-t' flag, while the output with '-t'
> flag is much more machine-readable-friendly, and thus should have the
> highest possible performance. e.g.:

I disagree, the "-t" mode is for the human; the non '-t' mode would be for machine (if you take the space as separator and the first word as key, with the exception of the path which starts from the "path " word and ends to the end of line); unfortunately "top level" is an exception. Anyway btrfs is not very machine-friendly (sic).


Compare the two output below:

$ sudo btrfs sub list -a /
ID 257 gen 44309 top level 5 path <FS_TREE>/debian
ID 289 gen 17415 top level 257 path debian/var/lib/machines
ID 298 gen 35434 top level 5 path <FS_TREE>/debian-i32
ID 299 gen 43961 top level 5 path <FS_TREE>/boot
ID 300 gen 39452 top level 5 path <FS_TREE>/debian-jessie

$ sudo btrfs sub list -at / 
ID	gen	top level	path	
--	---	---------	----	
257	44310	5		<FS_TREE>/debian
289	17415	257		debian/var/lib/machines
298	35434	5		<FS_TREE>/debian-i32
299	43961	5		<FS_TREE>/boot
300	39452	5		<FS_TREE>/debian-jessie


I think that is easy to declare the latter more "human" friendly. 

BTW with the use of the table_* function the output become:

$ sudo ./btrfs sub list -at / 
ID  gen   top level path                   
=== ===== ========= =======================
257 44311         5 <FS_TREE>/debian       
289 17415       257 debian/var/lib/machines
298 35434         5 <FS_TREE>/debian-i32   
299 43961         5 <FS_TREE>/boot         
300 39452         5 <FS_TREE>/debian-jessie

$ sudo ./btrfs sub list -aptcguqR / 
ID  gen   cgen  parent top level parent_uuid received_uuid uuid                                 path                   
=== ===== ===== ====== ========= =========== ============= ==================================== =======================
257 44313     7      5         5           -             - 840c86cf-e78b-d54a-ab38-66662858812d <FS_TREE>/debian       
289 17415 17415    257       257           -             - 8b857250-3a3e-754d-810e-57342bbb2f56 debian/var/lib/machines
298 35434 35399      5         5           -             - 1f38049b-b153-d741-b903-d2de6fd7b3fd <FS_TREE>/debian-i32   
299 43961 35512      5         5           -             - f9d52b6b-a6d1-8c45-a6cd-ddb68cf58062 <FS_TREE>/boot         
300 39452 37744      5         5           -             - 026e44bd-66d4-e341-9a14-0124acf79793 <FS_TREE>/debian-jessie

I right aligned each field with the exception of the path (which is left aligned).
I already prepared the patch which convert "btrfs sub list -t" to use the table_* function. If you want I can send it to you to extend/replace your patch #4.

BR
G.Baroncelli






> 
>   btrfs sub list  -t / | (read th; while read $th ; do echo $gen; done)
>   btrfs sub list -t | column -t
> 
> Again, this is just my opinion, being a "unix-purist". Maybe a good
> compromise would be to use a single "\t" instead of " " as column delimiter.




> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
