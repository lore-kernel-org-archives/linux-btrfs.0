From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: [PATCH 00/21] Btrfs: restriper
Date: Tue, 14 Feb 2012 11:15:39 -0500
Message-ID: <CALJXSJpXZL8cx=TvuoGhnh9s8VukWn=Ou3q9Pu=ob6BwqBkoqg@mail.gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
	<CALJXSJpjmb2F=fg_KML_W61gRPfiFH8Drz-H+uukn9d4owdwTg@mail.gmail.com>
	<20120214141843.GA1987@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120214141843.GA1987@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2012 at 9:18 AM, Ilya Dryomov <idryomov@gmail.com> wrote:
>
> Just to be sure, could you please paste the output of
> `btrfs-debug-tree -d <your device>' somewhere ?

Here it is: http://paste.pocoo.org/show/550900/

I also had btrsck errors before and still have them with 3 new after
balance (I guess it duplicated them :)
root 424 inode 291690 errors 400
root 424 inode 18446744073709551604 errors 2000
root 424 inode 18446744073709551605 errors 1

Full btrfsck: http://paste.pocoo.org/show/550902/
