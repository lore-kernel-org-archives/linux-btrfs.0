Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbbC0VtK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Mar 2015 17:49:10 -0400
Message-ID: <5515D052.60403@redhat.com>
Date: Fri, 27 Mar 2015 16:49:06 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Eryu Guan <guaneryu@gmail.com>
CC: Chris Mason <clm@fb.com>, fdmanana@gmail.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: I think "btrfs: fix leak of path in btrfs_find_item" broke stable
 trees ...
References: <55137BE2.80603@redhat.com> <CAL3q7H4fYq4K2rAT401QKSYKjRyaZwHDVSg6YZ0P=XU_31fLFQ@mail.gmail.com> <5514137E.6080804@redhat.com> <1427381284.28930.5@mail.thefacebook.com> <55143DD7.2020608@redhat.com> <20150327033432.GB16812@dhcp-13-216.nay.redhat.com>
In-Reply-To: <20150327033432.GB16812@dhcp-13-216.nay.redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/26/15 10:34 PM, Eryu Guan wrote:

> Just FYI.
> 
> I think generic/204 is a test case issue, _filter_mkfs failed to print
> isize and dbsize for btrfs and test failed because of divide by zero
> error.
> 
> --- /dev/fd/63	2015-03-25 12:17:05.987107715 -0400
> +++ results/generic/204.out.bad		      2015-03-25 12:17:05.423101244 -0400
> @@ -1,2 +1,3 @@
>  QA output created by 204
>  +./tests/generic/204: line 76: space / (isize + dbsize): division by 0 (error token is ")")
>   *** done
> 
> I'm working a patch for fstests.

Sorry, I beat you to it :)

-Eric

