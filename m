Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbcG3P5U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 11:57:20 -0400
Subject: Re: btrfs: relocation: Fix leaking qgroups numbers on data extents
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20160614092622.15560-1-quwenruo@cn.fujitsu.com>
 <20160729184235.GA3535@merlin.lan>
 <01f5daa5-779b-954b-0d8c-1f4bd54c10fe@gmx.com>
Cc: mfasheh@suse.de, linux-btrfs@vger.kernel.org, fdmanana@gmail.com
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <bbcce409-52ee-fcc8-daea-86a4c1221cf8@suse.de>
Date: Sat, 30 Jul 2016 10:57:15 -0500
MIME-Version: 1.0
In-Reply-To: <01f5daa5-779b-954b-0d8c-1f4bd54c10fe@gmx.com>
Content-Type: multipart/mixed;
 boundary="------------64195764D9D6669C73E0DE7F"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------64195764D9D6669C73E0DE7F
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit



On 07/29/2016 08:06 PM, Qu Wenruo wrote:
> Hi, Goldwyn,
> 
> This patch is replaced by the following patchset:
> https://patchwork.kernel.org/patch/9213915/
> https://patchwork.kernel.org/patch/9213913/
> 
> Would you mind testing the new patch?
> 


Sorry, it fails. Actually, the previous patch fails on one of the more
aggressive tests by Mark. So, I would revoke my "Tested-by: " there.

Attached is Mark's test case. Make sure your /boot and /usr directories
have enough files.


-- 
Goldwyn

--------------64195764D9D6669C73E0DE7F
Content-Type: application/x-shellscript;
 name="reproduce-1.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="reproduce-1.sh"

IyEvYmluL2Jhc2ggLXgKCk1OVD0iL2J0cmZzIgpERVY9Ii9kZXYvdmRiMSIKCm1rZnMuYnRy
ZnMgLWYgJERFViAgCm1vdW50IC10IGJ0cmZzICRERVYgJE1OVAoKbWtkaXIgJE1OVC9zbmFw
cwplY2hvICJwb3B1bGF0ZSAkTU5UIHdpdGggc29tZSBkYXRhIgojY3AgLWEgL3Vzci9zaGFy
ZS9mb250cyAkTU5ULwpjcCAtYSAvdXNyLyAkTU5ULyAmCmZvciBpIGluIGBzZXEgLXcgMCA4
YDsgZG8KICAgICAgICBTPSIkTU5UL3NuYXBzL3NuYXAkaSIKICAgICAgICBlY2hvICJjcmVh
dGUgYW5kIHBvcHVsYXRlICRTIgogICAgICAgIGJ0cmZzIHN1IHNuYXAgJE1OVCAkUzsKICAg
ICAgICBjcCAtYSAvYm9vdCAkUzsKZG9uZTsKCiNsZXQgdGhlIGNwIGZyb20gYWJvdmUgZmlu
aXNoCndhaXQKCmJ0cmZzIGZpIHN5bmMgJE1OVAoKYnRyZnMgcXVvdGEgZW5hYmxlICRNTlQK
YnRyZnMgcXVvdGEgcmVzY2FuIC13ICRNTlQKYnRyZnMgcWcgc2hvdyAkTU5UCgp1bW91bnQg
JE1OVAoKbW91bnQgLXQgYnRyZnMgJERFViAkTU5UCgoKdGltZSBidHJmcyBiYWxhbmNlIHN0
YXJ0IC0tZnVsbC1iYWxhbmNlICRNTlQKCnVtb3VudCAkTU5UCgpidHJmc2NrICRERVYK
--------------64195764D9D6669C73E0DE7F--
