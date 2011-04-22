From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Fri, 22 Apr 2011 13:49:24 -0700
Message-ID: <4DB1E9D4.3080107@oracle.com>
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <20110422200945.GA15387@elie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hch@infradead.org
To: Jonathan Nieder <jrnieder@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110422200945.GA15387@elie>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/22/2011 01:10 PM, Jonathan Nieder wrote:
> Hi,
>
> Josef Bacik wrote:
>
>> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
>> using fiemap in things like cp cause more problems than it solves, so lets try
>> and give userspace an interface that doesn't suck.  So we have
> That's easy to believe, but could you elaborate?  What problem does
> using fiemap cause?  I assume the answer is somewhere in somewhere in
> the thread
>
>   http://thread.gmane.org/gmane.comp.file-systems.xfs.general/37895/focus=24404
>
> but it would be nice to have a summary in the commit log for
> posterity.

http://article.gmane.org/gmane.comp.file-systems.ext4/24465
