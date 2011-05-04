From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Wed, 04 May 2011 15:22:03 -0400
Message-ID: <4DC1A75B.7040507@redhat.com>
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <15392.1304535887@localhost>            <4DC1A49C.4010101@redhat.com> <16280.1304536851@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16280.1304536851@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/04/2011 03:20 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 04 May 2011 15:10:20 EDT, Josef Bacik said:
>
>> Yeah sorry the log says "nearest" but the code says "next", if you look
>> at it thats how it works.  Thanks,
>
> Oh good - the changelog is usually easier to fix than the code is. :)
>
> Probably want to fix the changelog before it gets committed, as there's a fair
> chance that text will end up being used as the basis for a manpage or other
> documentation.
>

Yeah agreed I meant to change it this time around but forgot, I will 
make the log all nice and pretty next time around, as I doubt this will 
be the last iteration of these patches ;).  Thanks,

Josef
