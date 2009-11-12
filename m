From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: btrfsck: checksum verify failed
Date: Thu, 12 Nov 2009 05:08:53 +0300
Message-ID: <a4423d670911111808i3affd6d4q4aa14c6086d9c28f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

# for i in `seq 1 20`; do btrfsck /dev/sde|grep "checksum verify
failed";echo; done
checksum verify failed on 31945617408 wanted 6607632D found 9CC3ED0
checksum verify failed on 31945617408 wanted 6607632D found AFBBF41

checksum verify failed on 31945617408 wanted 6607632D found A4F0ED0
checksum verify failed on 31945617408 wanted 6607632D found B7E8F41

checksum verify failed on 31945617408 wanted 6607632D found A83DED0
checksum verify failed on 31945617408 wanted 6607632D found BB35F41

checksum verify failed on 31945617408 wanted 6607632D found A0D5ED0
checksum verify failed on 31945617408 wanted 6607632D found B3CDF41

checksum verify failed on 31945617408 wanted 6607632D found A37BED0
checksum verify failed on 31945617408 wanted 6607632D found B673F41

checksum verify failed on 31945617408 wanted 6607632D found AB7FED0
checksum verify failed on 31945617408 wanted 6607632D found BE77F41

checksum verify failed on 31945617408 wanted 6607632D found AB73ED0
checksum verify failed on 31945617408 wanted 6607632D found BE6BF41

checksum verify failed on 31945617408 wanted 6607632D found A76DED0
checksum verify failed on 31945617408 wanted 6607632D found BA65F41

checksum verify failed on 31945617408 wanted 6607632D found 98E6ED0
checksum verify failed on 31945617408 wanted 6607632D found ABDEF41

checksum verify failed on 31945617408 wanted 6607632D found 9038ED0
checksum verify failed on 31945617408 wanted 6607632D found A330F41

checksum verify failed on 31945617408 wanted 6607632D found A150ED0
checksum verify failed on 31945617408 wanted 6607632D found B448F41

checksum verify failed on 31945617408 wanted 6607632D found 916CED0
checksum verify failed on 31945617408 wanted 6607632D found A464F41

checksum verify failed on 31945617408 wanted 6607632D found 9277ED0
checksum verify failed on 31945617408 wanted 6607632D found A56FF41

checksum verify failed on 31945617408 wanted 6607632D found A9C4ED0
checksum verify failed on 31945617408 wanted 6607632D found BCBCF41

checksum verify failed on 31945617408 wanted 6607632D found A81CED0
checksum verify failed on 31945617408 wanted 6607632D found BB14F41

checksum verify failed on 31945617408 wanted 6607632D found A886ED0
checksum verify failed on 31945617408 wanted 6607632D found BB7EF41

checksum verify failed on 31945617408 wanted 6607632D found 944AED0
checksum verify failed on 31945617408 wanted 6607632D found A742F41

It looks like
10XX XXXXXXXX XXXX1110 11010000
and
10XX XXXXXXXX XXXX1111 01000001
