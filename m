From: dima <dolenin@parallels.com>
Subject: Re: Set nodatacow per file?
Date: Tue, 14 Feb 2012 00:10:23 +0900
Message-ID: <4F3927DF.3020401@parallels.com>
References: <4F38B8F0.5020506@yahoo.com> <4F38BE53.4080204@parallels.com> <20120213141040.GG15350@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213141040.GG15350@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/13/2012 11:10 PM, David Sterba wrote:
> Hi,
>
> On Mon, Feb 13, 2012 at 04:40:03PM +0900, dima wrote:
>> Actually it is possible. Check out David's response to my question from
>> some time ago:
>> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/14227
>
> this was a quick aid, please see attached file for an updated tool to set
> the file flags, now added 'z' for NOCOMPRESS flag, and supports chattr
> syntax plus all of the standard file flags.
>
> Setting and unsetting nocow is done like 'fileflags +C file' or -C for
> unseting. Without any + or - options it prints current state.
>
>
> david

Thanks David. Perfect! This would be a great help.
~dima
