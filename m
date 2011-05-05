From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:149!
Date: Thu, 05 May 2011 14:57:17 -0400
Message-ID: <4DC2F30D.3080308@redhat.com>
References: <201105051954.48405.whirm@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: whirm@gmx.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051954.48405.whirm@gmx.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/05/2011 01:54 PM, whirm@gmx.com wrote:
> On Thursday 05 May 2011 19:53:52 Josef Bacik wrote:
> [...]
>> Hmm I didn't see what I needed, can you do it again and try to get kernel
>> messages to go to /var/log/messages so you don't have to worry about the
>> log buffer?  The other option is to setup netconsole which would grab
>> everything. Thanks,
>
> Ok, this is all of it.
>

It doesn't look like that bit had my debugging output.  Thanks,

Josef
