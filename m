From: cwillu <cwillu@cwillu.com>
Subject: Re: subvolume nomenclature
Date: Fri, 2 Mar 2012 13:59:19 -0600
Message-ID: <CAE5mzvgGtQMXWzndahMKyX2iV9QjVO4T9=9V1ifnSrxMnwM1bQ@mail.gmail.com>
References: <jiqi3l$d4k$1@dough.gmane.org>
	<CAE5mzvhsb+O6xEvpOW5nh7iLgk5M+mgFD_ASVCpM0P==LSANqQ@mail.gmail.com>
	<jir7vn$3uc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jir7vn$3uc$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 2, 2012 at 1:44 PM, Brian J. Murrell <brian@interlinx.bc.ca=
> wrote:
> On 12-03-02 08:36 AM, cwillu wrote:
>>
>> Try btrfs sub delete /etc/apt/oneiric, assuming that that's the path
>> where you actually see it.
>
> Well, there is a root filesystem at /etc/apt/oneiric:
>
> # ls /etc/apt/oneiric/
> bin =C2=A0 etc =C2=A0 =C2=A0 =C2=A0 =C2=A0 initrd.img.old =C2=A0mnt =C2=
=A0 root =C2=A0selinux =C2=A0tmp =C2=A0vmlinuz
> boot =C2=A0home =C2=A0 =C2=A0 =C2=A0 =C2=A0lib =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 opt =C2=A0 run =C2=A0 srv =C2=A0 =C2=A0 =C2=A0usr =C2=
=A0vmlinuz.old
> dev =C2=A0 initrd.img =C2=A0media =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
proc =C2=A0sbin =C2=A0sys =C2=A0 =C2=A0 =C2=A0var
>
> but it doesn't delete:
>
> # btrfs subvolume delete /etc/apt/oneiric
> Delete subvolume '/etc/apt/oneiric'
> ERROR: cannot delete '/etc/apt/oneiric' - Device or resource busy

root@repository:~/foo$ btrfs sub create bar
Create subvolume './bar'
root@repository:~/foo$ cd bar
root@repository:~/foo/bar$ btrfs sub del /home/cwillu/foo/bar
Delete subvolume '/home/cwillu/foo/bar'
ERROR: cannot delete '/home/cwillu/foo/bar' - Device or resource busy


It's likely there's at least one process with an open handle to that
subvolume (even just a shell that as its current working directory).
lsof | grep /etc/apt/oneiric should tell you what you need.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
