From: Josef Bacik <josef@redhat.com>
Subject: Re: space cache generation (...) does not match inode (...)
Date: Mon, 08 Aug 2011 08:14:42 -0400
Message-ID: <4E3FD332.5020002@redhat.com>
References: <CAObL_7Hc0AGOB8Jk-o_hseiqxEfDWFLSnMkhLLiu00GVbr729Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrew Lutomirski <luto@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAObL_7Hc0AGOB8Jk-o_hseiqxEfDWFLSnMkhLLiu00GVbr729Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/06/2011 10:16 PM, Andrew Lutomirski wrote:
> I've always gotten space cache generation warnings, but some time
> after 3.0 they started going nuts.  I get:
> 
> space cache generation (14667727114112179905) does not match inode (154185)
> 
> and other similar messages (with a huge number and a smaller number)
> at rates higher than one message per ms.  They don't happen
> constantly, but they come in bursts big enough to fill my log buffer.
> 

Yeah sorry that's going to happen when you first switch to 3.0.  We
switched the space cache stuff over to using the normal checksumming
code so all old space cache is going to look invalid.  This is nothing
to worry about, it will just end up discarded and re-generated.  Thanks,

Josef
