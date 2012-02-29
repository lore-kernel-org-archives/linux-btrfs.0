From: cwillu <cwillu@cwillu.com>
Subject: Re: Set nodatacow per file?
Date: Wed, 29 Feb 2012 09:34:01 -0600
Message-ID: <CAE5mzviA4OVO=a=yyov9ysim0cMvRr3HjDOZUSCn-GcH5S8f5Q@mail.gmail.com>
References: <4F38B8F0.5020506@yahoo.com>
	<4F38BE53.4080204@parallels.com>
	<20120213141040.GG15350@twin.jikos.cz>
	<COL113-W608CD6CB84D365D60C7B7FB06F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Kyle Gates <kylegates@hotmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <COL113-W608CD6CB84D365D60C7B7FB06F0@phx.gbl>
List-ID: <linux-btrfs.vger.kernel.org>

> I get the following errors when running fileflags on large (>2GB) database files:
>
> open(): No such file or directory
>
> open(): Value too large for defined data type

http://www.gnu.org/software/coreutils/faq/#Value-too-large-for-defined-data-type

"""The message "Value too large for defined data type" is a system
error message reported when an operation on a large file is attempted
using a non-large file data type. Large files are defined as anything
larger than a signed 32-bit integer, or stated differently, larger
than 2GB.

Many system calls that deal with files return values in a "long int"
data type. On 32-bit hardware a long int is 32-bits and therefore this
imposes a 2GB limit on the size of files. When this was invented that
was HUGE and it was hard to conceive of needing anything that large.
Time has passed and files can be much larger today. On native 64-bit
systems the file size limit is usually 2GB * 2GB. Which we will again
think is huge."""
