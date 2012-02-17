From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Subject: Re: Premature ENOSPC only with zlib Compression
Date: Fri, 17 Feb 2012 17:34:42 +0100
Message-ID: <CAFDW0jKA4s-Z9RnpLOdSME4xRuokZqjVeEEO+ZAC9b8Qp5GHqQ@mail.gmail.com>
References: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com>
	<CAFDW0jLfLtEpnijsratvGho8RzC9D7nJD8H2y0SdZ6AxYeGpYw@mail.gmail.com>
	<201202162131.38463.chris@csamuel.org>
	<CAFDW0jJgNxNXJHiJxur+QaPAioyAyZ+-ftnTtZ2rR69Tqy0bfw@mail.gmail.com>
	<20120216175536.GL21896@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Ahmet Inan <ainan@mathematik.uni-freiburg.de>,
	Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120216175536.GL21896@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 16, 2012 at 6:55 PM, Chris Mason <chris.mason@oracle.com> wrote:
> On Thu, Feb 16, 2012 at 04:05:40PM +0100, Ahmet Inan wrote:
>> On Thu, Feb 16, 2012 at 11:31 AM, Chris Samuel <chris@csamuel.org> wrote:
>> > On Thursday 16 February 2012 19:06:52 Ahmet Inan wrote:
>> >
>> >> and got ENOSPC again :(
>> >>
>> >> so it doesnt matter if lzo or zlib: ENOSPC with compression
>> >> enabled!
>> >>
>> >> my kernel: vanilla 3.2.5
>> >
>> > I know that there has been an ENOSPC fix go in to the 3.3 RC kernels
>> > since the 3.2 release, any chance you'd be able to see if it still
>> > happens with the current 3.3 RC ?
>>
>> just tested 3.3.0-rc3, and it works like a charm!
>>
>> but there are lots of issues with external packages not compiling with 3.3,
>> why i wont be able to deploy it to our systems here yet.
>>
>> could this one bugfix be backported to 3.2?
>
> All of the btrfs patches in 3.3-rc are against 3.2 in my git tree:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

thank you very much, it works as it should.
had to couse some traffic on kernel.org but finally i got a local linux repo!

is for-linus considered stable and can i pull regularly?

here what i did for those interested:

cd /usr/src/
rm linux
git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux
cd linux
git checkout linux-3.2.y
git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
for-linus
cp /boot/config .config
make menuconfig
# look around, save and exit
make -j8
make modules_install
make install

and thats it, 3.2.6 stable kernel from git with latest for-linus btrfs from git

Ahmet
