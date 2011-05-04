From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Wed, 04 May 2011 15:10:20 -0400
Message-ID: <4DC1A49C.4010101@redhat.com>
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <15392.1304535887@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <15392.1304535887@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/04/2011 03:04 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 04 May 2011 13:58:39 EDT, Josef Bacik said:
>
>> -SEEK_HOLE: this moves the file pos to the nearest hole in the file from the
>> given position.
>
> Nearest, or next? Solaris defines it as "next", for a good reason - otherwise
> you can get stuck in a case where the "nearest" hole is back towards the
> start of the file - and "seek data" will bounce back to the next byte at
> the other end of the hole.
>

Yeah sorry the log says "nearest" but the code says "next", if you look 
at it thats how it works.  Thanks,

Josef
