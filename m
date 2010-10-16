From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: btrfs filesystem df not working
Date: Sat, 16 Oct 2010 14:46:14 +0100
Message-ID: <AANLkTinaO7p-yc=eiTOt+wLSVJuJAH3oyG0sKYxJ366y@mail.gmail.com>
References: <AANLkTik-414saDjSZFtEKWn4h7zSbbLBqa_0S+uf4SQR@mail.gmail.com>
	<AANLkTi=1VgjsZoJqzkp-zto3vAMUThh7TN054xQ1mpEu@mail.gmail.com>
	<AANLkTinYN+b=5qU_+pC_O6OK96JXez8QQeifdzC8dkCK@mail.gmail.com>
	<20101013004332.GK22691@think>
	<AANLkTinta=KNbF2Poync8oSTCQSsjvFErBsmGUrkpGSg@mail.gmail.com>
	<20101013150237.GU22691@think>
	<AANLkTimRTycuHq6aWir=ZJUAHKc1rb6QXteLG7sMN6ge@mail.gmail.com>
	<20101014164230.GX22691@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Leonidas Spyropoulos <artafinde@gmail.com>,
	cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101014164230.GX22691@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 14, 2010 at 5:42 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Thu, Oct 14, 2010 at 12:45:59PM +0100, Leonidas Spyropoulos wrote:
>> On Wed, Oct 13, 2010 at 4:08 PM, Chris Mason <chris.mason@oracle.com=
> wrote:
>> > On Wed, Oct 13, 2010 at 10:52:57AM +0100, Leonidas Spyropoulos wro=
te:
>> >> On Wed, Oct 13, 2010 at 1:43 AM, Chris Mason <chris.mason@oracle.=
com> wrote:
>> >> > On Tue, Oct 12, 2010 at 02:45:19PM +0100, Leonidas Spyropoulos =
wrote:
>> >> >> On Tue, Oct 12, 2010 at 2:43 PM, cwillu <cwillu@cwillu.com> wr=
ote:
>> >> >> > On Tue, Oct 12, 2010 at 4:12 AM, Leonidas Spyropoulos
>> >> >> > <artafinde@gmail.com> wrote:
>> >> >> >> The above command is not working on my system.
>> >> >> >> Information:
>> >> >> >> btrfs f df /media/data
>> >> >> >
>> >> >> > btrfs f isn't unique; =A0fi is the minimum to specify "files=
ystem"
>> >> >> >
>> >> >> I tried even with btrfs filesystem df /media/data
>> >> >> and same results.
>> >> >
>> >> > Does strace give us any clues?
>> >> >
>> >> According to strace there is inappropriate ioctl for the device.
>> >> Here is the log
>> >
>> > I missed this before:
>> >
>> > 2.6.32-5-amd64
>> >
>> > The df ioctl was added after 2.6.32 (2.6.33 I think).
>>
>> So in debian squeeze/unstable which is currently on 2.6.32 (and won'=
t
>> change any sooner) I cannot use btrfs. All I can do is try
>> experimental kernels?
>
> Or backport the changes, yes.
Sorry, I don't understand what "backport the changes" means?

>
>> My question though is, if I use experimental kernels can I then load
>> an "old" kernel and still use the btrfs filesystem?
>> Or the newer kernels write anything specials on ionodes which the ol=
d
>> ones cannot read?
>
> We haven't made any of those changes, you'll be fine going back and
> forth.
>
> -chris
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
