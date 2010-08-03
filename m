From: Xavier Nicollet <nicollet@jeru.org>
Subject: Re: birgers RFE #2
Date: Tue, 3 Aug 2010 16:33:13 +0200
Message-ID: <20100803143313.GN30325@jeru.org>
References: <1280839481.31210.10.camel@sch30110.bergens-tidende.no> <20100803134812.GK30325@jeru.org> <AANLkTimizt+Eh+B+cViWXUBa9J1i0XVK2qU0bEmcVfMB@mail.gmail.com>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Benjamin Griese <der.darude@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimizt+Eh+B+cViWXUBa9J1i0XVK2qU0bEmcVfMB@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Le 03 ao=FBt 2010 =E0 15:42, Benjamin Griese a =E9crit:
> Hello guys,
> I would be interested in that script, maybe in both of yours,

It is not supposedly bulletproof. Use at your own risks.
backup1:/usr/local/bin# crontab -l
# m h  dom mon dow   command
# hourly backup
0 * * * *  /usr/local/bin/snapshots.py -h     =20
# daily backup
10 6 * * *  /usr/local/bin/snapshots.py -d
# weekly backup
#20 6 * * 0 /usr/local/bin/snapshots.py -w
# monthly backup
#30 6 1 * * /usr/local/bin/snapshots.py -m
# yearly backup
#40 6 1 1 * /usr/local/bin/snapshots.py -y


#! /usr/bin/env python

""" Daily snapshots for all our backups """

import os
import os.path
import glob
import sys
import subprocess
import time
import re



def usage():
        """ Print usage and exit """
        print "usage: %s [-y|-m|-d|-h]" % sys.argv[0]
        sys.exit(2)

def chdir_force(path):
        """ Chdir even if we have to make the path """
        try:
                os.makedirs(path)
        except OSError:
                pass
        os.chdir(path)

class Tuning:
        tuning =3D {
                '-y' : [ 'yearly', 1 ],   # we keep 1 snapshots
                '-m' : [ 'monthly', 1 ],  # we keep 1 snapshots
                '-w' : [ 'weekly', 1 ],   # we keep 1 weekly snapshots
                '-d' : [ 'daily', 4 ],
                '-h' : [ 'hourly', 2 ],
        }

        def __init__(self):
                try:
                        option =3D sys.argv[1]
                        (self.mode, self.keep) =3D Tuning.tuning[option=
]
                except (IndexError, KeyError):
                        usage()

def get_backup_name():
        """ Return the backup dir name.=20
                It depends on the current location and time. """
        name =3D time.strftime("backup-%y-%m-%d-%H:%M:%S")
        if os.path.exists(name):
                print "name already exists"
                sys.exit(2)
        return name

def main():
        tuning =3D Tuning()

        backup_path =3D os.path.join("/mnt/btrfs/history", tuning.mode)
        chdir_force(backup_path)

        # Make the new snapshot
        cmd =3D "/usr/local/bin/btrfs subvolume snapshot".split()
        backup_name =3D get_backup_name()
        cmd.extend( ["/backup/", backup_name] )
        ret =3D subprocess.call(cmd)
        if ret !=3D 0:
                print "return from btrfs subvol snap: " + str(ret)

        # Filter the number of snapshots
        files =3D sorted( (file for file in glob.glob( "backup-*") if n=
ot file.endswith(".old")) )
        if len(files) > tuning.keep:
                for file in files[:-tuning.keep]:
                        cmd =3D "/usr/local/bin/btrfs subvolume delete =
".split()
                        cmd.append( file )  =20
                        ret =3D subprocess.call(cmd)
                        if ret !=3D 0:
                                print "return from btrfs subvol del: " =
+ ret

if __name__ =3D=3D '__main__':
        main()




--=20
Xavier Nicollet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
